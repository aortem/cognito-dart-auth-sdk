import 'package:test/test.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_mfa_preference_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Fake HttpClient for unit testing
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
  group('   CognitoAdminSetUserMFAPreferenceRequest', () {
    test('sends correct payload and target', () async {
      final fake = FakeHttpClient();

      final req = CognitoAdminSetUserMFAPreferenceRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        smsMfaSettings: {'Enabled': true, 'PreferredMfa': true},
        softwareTokenMfaSettings: {'Enabled': true, 'PreferredMfa': false},
        region: 'us-west-2',
        httpClient: fake,
      );

      final res = await req.execute();

      expect(
        fake.lastTarget,
        'AWSCognitoIdentityProviderService.AdminSetUserMFAPreference',
      );
      expect(fake.lastPayload?['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(fake.lastPayload?['Username'], 'testuser');
      expect(fake.lastPayload?['SMSMfaSettings']?['Enabled'], true);
      expect(res.json, isA<Map<String, dynamic>>());
    });

    test('throws if userPoolId missing', () {
      final fake = FakeHttpClient();
      expect(
        () => CognitoAdminSetUserMFAPreferenceRequest(
          userPoolId: '',
          username: 'testuser',
          region: 'us-west-2',
          httpClient: fake,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
