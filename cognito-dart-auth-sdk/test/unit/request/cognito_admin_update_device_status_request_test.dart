import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_device_status_request.dart';
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
  group('CognitoAdminUpdateDeviceStatusRequest', () {
    test('sends remembered status with AWS target and payload', () async {
      final client = _RecordingClient();
      final request = CognitoAdminUpdateDeviceStatusRequest(
        userPoolId: 'us-west-2_POOL',
        username: 'testuser',
        deviceKey: 'us-west-2_device-key',
        deviceRememberedStatus: 'remembered',
        region: 'us-west-2',
        httpClient: client,
      );

      final result = await request.execute();

      expect(result, isA<CognitoAdminUpdateDeviceStatusResult>());
      expect(
        client.target,
        'AWSCognitoIdentityProviderService.AdminUpdateDeviceStatus',
      );
      expect(client.payload, containsPair('UserPoolId', 'us-west-2_POOL'));
      expect(client.payload, containsPair('Username', 'testuser'));
      expect(client.payload, containsPair('DeviceKey', 'us-west-2_device-key'));
      expect(
        client.payload,
        containsPair('DeviceRememberedStatus', 'remembered'),
      );
    });

    test('validates device remembered status', () {
      expect(
        () => CognitoAdminUpdateDeviceStatusRequest(
          userPoolId: 'us-west-2_POOL',
          username: 'testuser',
          deviceKey: 'us-west-2_device-key',
          deviceRememberedStatus: 'invalid',
          region: 'us-west-2',
          httpClient: _RecordingClient(),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws service exception on client error', () {
      final request = CognitoAdminUpdateDeviceStatusRequest(
        userPoolId: 'us-west-2_POOL',
        username: 'testuser',
        deviceKey: 'us-west-2_device-key',
        deviceRememberedStatus: 'not_remembered',
        region: 'us-west-2',
        httpClient: _RecordingClient(statusCode: 400, body: '{"error":"bad"}'),
      );

      expect(() => request.execute(), throwsA(isA<Exception>()));
    });
  });
}
