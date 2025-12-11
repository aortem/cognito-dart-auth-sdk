// Adjust imports to your actual package name / paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  int statusCode = 200;
  String bodyString = '{"User":{"Username":"testuser"}}';

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastTarget = target;
    lastPayload = payload;
    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) {
    return send(
      service: 'cognito-idp',
      target: xAmzTarget,
      region: region,
      payload: payload,
      timeout: timeout ?? const Duration(seconds: 20),
      headers: additionalHeaders,
    );
  }
}

void main() {
  group('AdminCreateUserRequest (Ticket #7)', () {
    test('happy path: builds payload and returns result with User', () async {
      final http = _FakeHttp();

      final req = CognitoAdminCreateUserRequest(
        userPoolId: 'us-east-1_EXAMPLE',
        username: 'testuser',
        region: 'us-east-1',
        httpClient: http,
        userAttributes: const [
          CognitoAttributeType(name: 'email', value: 'test@example.com'),
          CognitoAttributeType(name: 'name', value: 'John'),
        ],
        desiredDeliveryMediums: const ['EMAIL'],
        messageAction: CognitoMessageActionType.suppress,
        temporaryPassword: 'Temp#123456', // optional
      );

      final res = await req.execute();
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminCreateUser',
      );
      expect(http.lastPayload, isNotNull);
      expect(res.user?['Username'], 'testuser');

      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-east-1_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect((p['UserAttributes'] as List).length, 2);
      expect(p['DesiredDeliveryMediums'], ['EMAIL']);
      expect(p['MessageAction'], 'SUPPRESS');
      expect(p['TemporaryPassword'], 'Temp#123456');
    });

    test('validation: EMAIL delivery without email attribute throws', () {
      final http = _FakeHttp();
      expect(
        () => CognitoAdminCreateUserRequest(
          userPoolId: 'us-east-1_EXAMPLE',
          username: 'user1',
          region: 'us-east-1',
          httpClient: http,
          desiredDeliveryMediums: const ['EMAIL'],
          userAttributes: const [
            CognitoAttributeType(name: 'name', value: 'No Email'),
          ],
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });

    test('4xx from service throws    CognitoServiceException', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';

      final req = CognitoAdminCreateUserRequest(
        userPoolId: 'us-east-1_EXAMPLE',
        username: 'user2',
        region: 'us-east-1',
        httpClient: http,
        userAttributes: const [
          CognitoAttributeType(name: 'email', value: 'x@y.com'),
        ],
        desiredDeliveryMediums: const ['EMAIL'],
        maxRetries: 0,
      );

      expect(() => req.execute(), throwsA(isA<CognitoServiceException>()));
    });
  });
}
