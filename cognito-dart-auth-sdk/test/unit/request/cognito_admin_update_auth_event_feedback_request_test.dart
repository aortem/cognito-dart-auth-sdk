import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_auth_event_feedback_request.dart';
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
  group('   CognitoAdminUpdateAuthEventFeedbackRequest', () {
    test('builds payload correctly', () async {
      final client = FakeHttpClient();

      final req = CognitoAdminUpdateAuthEventFeedbackRequest(
        userPoolId: 'us-west-2_POOL',
        username: 'testuser',
        eventId: 'event123',
        feedbackValue: 'Valid',
        region: 'us-west-2',
        httpClient: client,
      );

      final result = await req.execute();
      expect(result.success, isTrue);
      expect(client.lastPayload, containsPair('UserPoolId', 'us-west-2_POOL'));
      expect(client.lastPayload, containsPair('FeedbackValue', 'Valid'));
    });
  });
}
