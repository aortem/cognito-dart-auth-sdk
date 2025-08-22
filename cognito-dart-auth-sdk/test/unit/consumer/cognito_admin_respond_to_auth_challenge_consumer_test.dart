import 'dart:async';

import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_respond_to_auth_challenge_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_respond_to_auth_challenge_request.dart';

/// Fake HTTP client that just returns a dummy 200 OK response.
class FakeHttpClient implements CognitoHttpClient {
  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    return CognitoHttpResponse(
      statusCode: 200,
      headers: {'content-type': 'application/json'},
      bodyString:
          '{"ChallengeName":"SOFTWARE_TOKEN_MFA","Session":"fake-session"}',
    );
  }

  // Implement send explicitly to silence the analyzer
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
  group('   CognitoAdminRespondToAuthChallengeConsumer', () {
    late FakeHttpClient fakeClient;
    late CognitoAdminRespondToAuthChallengeConsumer consumer;

    setUp(() {
      fakeClient = FakeHttpClient();
      consumer = CognitoAdminRespondToAuthChallengeConsumer(
        region: 'us-west-2',
        httpClient: fakeClient,
      );
    });

    test('runs successfully with valid builder values', () async {
      final result = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..clientId('1example23456789')
          ..challengeName('SOFTWARE_TOKEN_MFA')
          ..challengeResponses({
            'USERNAME': 'testuser',
            'SOFTWARE_TOKEN_MFA_CODE': '123456',
          })
          ..session('dummy-session-token'),
      );

      expect(result, isA<CognitoAdminRespondToAuthChallengeResult>());
    });
  });
}
