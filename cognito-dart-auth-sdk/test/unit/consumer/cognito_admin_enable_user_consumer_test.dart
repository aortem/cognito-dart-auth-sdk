import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_enable_user_consumer.dart';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_enable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '{}';

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
    lastRegion = region;
    lastHeaders = headers;
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
  group('AdminEnableUserConsumer (Ticket #18)', () {
    test('happy path: builds and sends minimal payload', () async {
      final http = _FakeHttp();

      final consumer = AortemCognitoAdminEnableUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser'),
      );

      expect(res, isA<AortemCognitoAdminEnableUserResult>());

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminEnableUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
    });

    test('missing requireds throw before HTTP', () {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminEnableUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // Missing username
      expect(
        () => consumer.run((b) => b..userPoolId('us-west-2_EXAMPLE')),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing userPoolId
      expect(
        () => consumer.run((b) => b..username('user')),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
