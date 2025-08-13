import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_create_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  int statusCode = 200;
  String bodyString = '{"User":{"Username":"testuser"}}';

  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastTarget = target;
    lastPayload = payload;
    return AortemCognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  @override
  Future<AortemCognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) => send(
    service: 'cognito-idp',
    target: xAmzTarget,
    region: region,
    payload: payload,
    timeout: timeout ?? const Duration(seconds: 20),
    headers: additionalHeaders,
  );
}

void main() {
  group('AdminCreateUserConsumer (Ticket #8)', () {
    test('happy path builds + sends payload with mediums and attrs', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminCreateUserConsumer(
        region: 'us-east-1',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-east-1_EXAMPLE')
          ..username('testuser')
          ..email('testuser@example.com')
          ..phoneNumber('+12065551212')
          ..deliveryEmail()
          ..messageSuppress()
          ..temporaryPassword('Temp#123456')
          ..customAttr('tier', 'gold')
          ..meta('origin', 'admin'),
      );

      expect(res, isA<AortemCognitoAdminCreateUserResult>());
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminCreateUser',
      );

      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-east-1_EXAMPLE');
      expect(p['Username'], 'testuser');

      final attrs = (p['UserAttributes'] as List).cast<Map>();
      expect(
        attrs.any(
          (m) => m['Name'] == 'email' && m['Value'] == 'testuser@example.com',
        ),
        isTrue,
      );
      expect(
        attrs.any(
          (m) => m['Name'] == 'phone_number' && m['Value'] == '+12065551212',
        ),
        isTrue,
      );
      expect(
        attrs.any((m) => m['Name'] == 'custom:tier' && m['Value'] == 'gold'),
        isTrue,
      );

      expect(p['DesiredDeliveryMediums'], contains('EMAIL'));
      expect(p['MessageAction'], 'SUPPRESS');
      expect(p['TemporaryPassword'], 'Temp#123456');
      expect(p['ClientMetadata'], {'origin': 'admin'});
    });

    test('missing requireds throw before HTTP', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminCreateUserConsumer(
        region: 'us-east-1',
        httpClient: http,
      );

      // Missing username
      expect(
        () => consumer.run((b) => b..userPoolId('us-east-1_EXAMPLE')),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing userPoolId
      expect(
        () => consumer.run((b) => b..username('user')),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test(
      'EMAIL medium without email attribute fails in Request validator',
      () async {
        final http = _FakeHttp();
        final consumer = AortemCognitoAdminCreateUserConsumer(
          region: 'us-east-1',
          httpClient: http,
        );

        expect(
          () => consumer.run(
            (b) => b
              ..userPoolId('us-east-1_EXAMPLE')
              ..username('user1')
              ..deliveryEmail(), // but no email attribute supplied
          ),
          throwsA(isA<AortemCognitoValidationException>()),
        );
      },
    );
  });
}
