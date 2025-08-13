// Adjust imports to your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_disable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

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
  group('AdminDisableUserRequest (Ticket #15)', () {
    test('happy path: 200 OK returns empty-success result', () async {
      final http = _FakeHttp();

      final req = AortemCognitoAdminDisableUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<AortemCognitoAdminDisableUserResult>());

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminDisableUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
    });

    test('validation: bad pool id throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminDisableUserRequest(
          userPoolId: 'badPoolId',
          username: 'user',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('validation: empty username throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminDisableUserRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx response throws AortemCognitoServiceException', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"UserNotFoundException"}';

      final req = AortemCognitoAdminDisableUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'missing',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0, // fail fast
      );

      expect(
        () => req.execute(),
        throwsA(isA<AortemCognitoServiceException>()),
      );
    });
  });
}
