import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_password_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class FakeHttpClient implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    lastPayload = payload;
    lastTarget = xAmzTarget;
    return CognitoHttpResponse(statusCode: 200, headers: {}, bodyString: '{}');
  }

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) {
    return post(
      region: region,
      xAmzTarget: target,
      payload: payload,
      additionalHeaders: headers,
      timeout: timeout,
    );
  }
}

void main() {
  group('AdminSetUserPasswordRequest', () {
    test('sends correct payload and target', () async {
      final fake = FakeHttpClient();
      final req = CognitoAdminSetUserPasswordRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        password: 'MyExamplePassword1=',
        permanent: true,
        region: 'us-west-2',
        httpClient: fake,
      );

      final res = await req.execute();

      expect(
        fake.lastTarget,
        'AWSCognitoIdentityProviderService.AdminSetUserPassword',
      );
      expect(fake.lastPayload?['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(fake.lastPayload?['Username'], 'testuser');
      expect(fake.lastPayload?['Password'], 'MyExamplePassword1=');
      expect(fake.lastPayload?['Permanent'], true);
      expect(res.success, true);
    });

    test('throws when missing username', () {
      final fake = FakeHttpClient();
      expect(
        () => CognitoAdminSetUserPasswordRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '',
          password: 'p',
          region: 'us-west-2',
          httpClient: fake,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
