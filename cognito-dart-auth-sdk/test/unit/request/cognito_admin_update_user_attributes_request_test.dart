import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_user_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart'
    show CognitoAttributeType;
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _RecordingClient extends CognitoHttpClient {
  String? target;
  Map<String, dynamic>? payload;
  int statusCode;
  String body;

  _RecordingClient({this.statusCode = 200, this.body = '{}'});

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    target = xAmzTarget;
    this.payload = payload;
    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: body,
    );
  }
}

void main() {
  group('CognitoAdminUpdateUserAttributesRequest', () {
    test('sends attributes and client metadata with AWS target', () async {
      final client = _RecordingClient();
      final request = CognitoAdminUpdateUserAttributesRequest(
        userPoolId: 'us-west-2_POOL',
        username: 'testuser',
        userAttributes: [
          CognitoAttributeType(name: 'email_verified', value: 'true'),
          CognitoAttributeType(name: 'custom:role', value: 'admin'),
        ],
        clientMetadata: const {'source': 'unit-test'},
        region: 'us-west-2',
        httpClient: client,
      );

      final result = await request.execute();

      expect(result, isA<CognitoAdminUpdateUserAttributesResult>());
      expect(
        client.target,
        'AWSCognitoIdentityProviderService.AdminUpdateUserAttributes',
      );
      expect(client.payload, containsPair('UserPoolId', 'us-west-2_POOL'));
      expect(client.payload, containsPair('Username', 'testuser'));
      expect(
        client.payload?['UserAttributes'],
        contains(
          predicate<Map<String, dynamic>>(
            (attribute) =>
                attribute['Name'] == 'email_verified' &&
                attribute['Value'] == 'true',
          ),
        ),
      );
      expect(
        client.payload?['ClientMetadata'],
        containsPair('source', 'unit-test'),
      );
    });

    test('validates required attributes', () {
      expect(
        () => CognitoAdminUpdateUserAttributesRequest(
          userPoolId: 'us-west-2_POOL',
          username: 'testuser',
          userAttributes: const [],
          region: 'us-west-2',
          httpClient: _RecordingClient(),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws service exception on client error', () {
      final request = CognitoAdminUpdateUserAttributesRequest(
        userPoolId: 'us-west-2_POOL',
        username: 'testuser',
        userAttributes: [
          CognitoAttributeType(name: 'nickname', value: 'tester'),
        ],
        region: 'us-west-2',
        httpClient: _RecordingClient(statusCode: 400, body: '{"error":"bad"}'),
      );

      expect(() => request.execute(), throwsA(isA<Exception>()));
    });
  });
}
