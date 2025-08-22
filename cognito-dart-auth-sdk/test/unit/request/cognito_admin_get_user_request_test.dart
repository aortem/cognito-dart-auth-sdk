// Adjust imports to your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '''
{
  "Enabled": true,
  "UserAttributes": [
    {"Name":"sub","Value":"a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"},
    {"Name":"email","Value":"testuser@example.com"},
    {"Name":"custom:deliverables","Value":"project-111222"}
  ],
  "UserCreateDate": 1682955829.578,
  "UserLastModifiedDate": 1722380161.794,
  "UserStatus": "CONFIRMED",
  "Username": "testuser",
  "UserMFASettingList": ["SMS_MFA","SOFTWARE_TOKEN_MFA"],
  "PreferredMfaSetting": "SOFTWARE_TOKEN_MFA"
}
''';

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
  group('AdminGetUserRequest (Ticket #23)', () {
    test('happy path: parses user and attributes', () async {
      final http = _FakeHttp();

      final req = CognitoAdminGetUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<CognitoAdminGetUserResult>());

      // HTTP wiring
      final p = http.lastPayload!;
      expect(http.lastTarget, 'AWSCognitoIdentityProviderService.AdminGetUser');
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      // Payload sent
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');

      // Parsed fields
      final u = res.user;
      expect(u.username, 'testuser');
      expect(u.enabled, isTrue);
      expect(u.attributes['email'], 'testuser@example.com');
      expect(u.attributes['custom:deliverables'], 'project-111222');
      expect(u.userMfaSettingList, contains('SMS_MFA'));
      expect(u.preferredMfaSetting, 'SOFTWARE_TOKEN_MFA');
      expect(u.userStatus, 'CONFIRMED');
      expect(u.userCreateDate, isNotNull);
      expect(u.userLastModifiedDate, isNotNull);
    });

    test('validation: rejects bad pool id / empty username', () {
      final http = _FakeHttp();

      // Bad pool id
      expect(
        () => CognitoAdminGetUserRequest(
          userPoolId: 'badPoolId',
          username: 'u',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<CognitoValidationException>()),
      );

      // Empty username
      expect(
        () => CognitoAdminGetUserRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });

    test('4xx response throws service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 404
        ..bodyString = '{"message":"UserNotFoundException"}';

      final req = CognitoAdminGetUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'missing',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0,
      );

      expect(() => req.execute(), throwsA(isA<CognitoServiceException>()));
    });
  });
}
