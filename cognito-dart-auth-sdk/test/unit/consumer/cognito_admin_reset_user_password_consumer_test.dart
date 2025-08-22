import 'dart:convert';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_reset_user_password_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_reset_user_password_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttpClient implements CognitoHttpClient {
  String? lastTarget;
  Map<String, dynamic>? lastPayload;

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
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({}),
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
  test('Consumer.run builds request via builder and succeeds', () async {
    final http = _FakeHttpClient();
    final consumer = CognitoAdminResetUserPasswordConsumer(
      region: 'us-west-2',
      httpClient: http,
    );

    final result = await consumer.run(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser')
        ..clientMetadata({'MyTestKey': 'MyTestValue'}),
    );

    expect(result, isA<CognitoAdminResetUserPasswordResult>());
    expect(
      http.lastTarget,
      'AWSCognitoIdentityProviderService.AdminResetUserPassword',
    );

    expect(http.lastPayload!['UserPoolId'], 'us-west-2_EXAMPLE');
    expect(http.lastPayload!['Username'], 'testuser');
    expect(http.lastPayload!['ClientMetadata'], {'MyTestKey': 'MyTestValue'});
  });
}
