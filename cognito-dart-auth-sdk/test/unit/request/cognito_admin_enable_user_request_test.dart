import 'package:ds_tools_testing/ds_tools_testing.dart';

// Adjust imports to your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_enable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '{}';

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
    lastRegion = region;
    lastHeaders = headers;
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
  group('AdminEnableUserRequest (Ticket #17)', () {
    test('happy path: 200 OK returns empty-success result', () async {
      final http = _FakeHttp();

      final req = CognitoAdminEnableUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<CognitoAdminEnableUserResult>());

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

    test('validation: bad pool id throws', () {
      final http = _FakeHttp();
      expect(
        () => CognitoAdminEnableUserRequest(
          userPoolId: 'badPoolId',
          username: 'user',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });

    test('validation: empty username throws', () {
      final http = _FakeHttp();
      expect(
        () => CognitoAdminEnableUserRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });

    test('4xx response throws    CognitoServiceException', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"UserNotFoundException"}';

      final req = CognitoAdminEnableUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'missing',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0, // fail fast
      );

      expect(() => req.execute(), throwsA(isA<CognitoServiceException>()));
    });
  });
}
