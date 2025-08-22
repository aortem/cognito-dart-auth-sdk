import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_update_auth_event_feedback_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class FakeHttpClient extends CognitoHttpClient {
  Map<String, dynamic>? lastPayload;

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    lastPayload = payload;
    return CognitoHttpResponse(statusCode: 200, headers: {}, bodyString: '{}');
  }
}

void main() {
  group('   CognitoAdminUpdateAuthEventFeedbackConsumer', () {
    test('executes via builder', () async {
      final client = FakeHttpClient();
      final consumer = CognitoAdminUpdateAuthEventFeedbackConsumer(
        region: 'us-west-2',
        httpClient: client,
      );

      final result = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_POOL')
          ..username('testuser')
          ..eventId('event123')
          ..feedbackValue('Invalid'),
      );

      expect(result.success, isTrue);
      expect(client.lastPayload, containsPair('FeedbackValue', 'Invalid'));
      expect(client.lastPayload, containsPair('EventId', 'event123'));
    });
  });
}
