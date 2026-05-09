import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_update_user_attributes_consumer.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _RecordingClient extends CognitoHttpClient {
  Map<String, dynamic>? payload;

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    this.payload = payload;
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: '{}',
    );
  }
}

void main() {
  group('CognitoAdminUpdateUserAttributesConsumer', () {
    test('builds and executes update request', () async {
      final client = _RecordingClient();
      final consumer = CognitoAdminUpdateUserAttributesConsumer(
        region: 'us-west-2',
        httpClient: client,
      );

      final result = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_POOL')
          ..username('testuser')
          ..attribute('custom:department', 'engineering')
          ..metadata('source', 'unit-test'),
      );

      expect(result, isA<Object>());
      expect(
        client.payload?['UserAttributes'],
        contains(
          predicate<Map<String, dynamic>>(
            (attribute) =>
                attribute['Name'] == 'custom:department' &&
                attribute['Value'] == 'engineering',
          ),
        ),
      );
      expect(
        client.payload?['ClientMetadata'],
        containsPair('source', 'unit-test'),
      );
    });
  });
}
