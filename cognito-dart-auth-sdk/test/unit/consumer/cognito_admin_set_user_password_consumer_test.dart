import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_set_user_password_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_password_request.dart';

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
  group('AdminSetUserPasswordConsumer', () {
    test('runs builder and calls request', () async {
      final fake = FakeHttpClient();
      final consumer = CognitoAdminSetUserPasswordConsumer(
        region: 'us-west-2',
        httpClient: fake,
      );

      final result = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser')
          ..password('MyExamplePassword1=')
          ..permanent(true),
      );

      expect(
        fake.lastTarget,
        'AWSCognitoIdentityProviderService.AdminSetUserPassword',
      );
      expect(fake.lastPayload?['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(fake.lastPayload?['Username'], 'testuser');
      expect(fake.lastPayload?['Password'], 'MyExamplePassword1=');
      expect(fake.lastPayload?['Permanent'], true);
      expect(result, isA<CognitoAdminSetUserPasswordResult>());
    });
  });
}
