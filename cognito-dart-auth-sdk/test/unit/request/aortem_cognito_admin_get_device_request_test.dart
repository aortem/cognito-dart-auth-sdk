import 'package:test/test.dart';

// Adjust imports to your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_get_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '''
{
  "Device": {
    "DeviceAttributes": [
      {"Name":"device_status","Value":"valid"},
      {"Name":"device_name","Value":"Dart-device"},
      {"Name":"last_ip_used","Value":"192.0.2.1"}
    ],
    "DeviceCreateDate": 1715100742.022,
    "DeviceKey": "us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222",
    "DeviceLastAuthenticatedDate": 1715100742.0,
    "DeviceLastModifiedDate": 1715100742.022
  }
}
''';

  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastTarget = target;
    lastRegion = region;
    lastHeaders = headers;
    lastPayload = payload;

    return AortemCognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  @override
  Future<AortemCognitoHttpResponse> post({
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
  group('AdminGetDeviceRequest (Ticket #21)', () {
    test('happy path: parses device and attributes', () async {
      final http = _FakeHttp();

      final req = AortemCognitoAdminGetDeviceRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        deviceKey: 'us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222',
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<AortemCognitoAdminGetDeviceResult>());

      final p = http.lastPayload!;
      expect(http.lastTarget, 'AWSCognitoIdentityProviderService.AdminGetDevice');
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['DeviceKey'], 'us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222');

      final dev = res.device;
      expect(dev.deviceKey, contains('us-west-2_'));
      expect(dev.attributes['device_status'], 'valid');
      expect(dev.attributes['device_name'], 'Dart-device');
      expect(dev.deviceCreateDate, isNotNull);
      expect(dev.deviceLastAuthenticatedDate, isNotNull);
      expect(dev.deviceLastModifiedDate, isNotNull);
    });

    test('validation: rejects bad pool id / username / deviceKey', () {
      final http = _FakeHttp();

      // Bad pool id
      expect(
        () => AortemCognitoAdminGetDeviceRequest(
          userPoolId: 'badPoolId',
          username: 'u',
          deviceKey: 'us-west-2_deadbeef-dead-beef',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Empty username
      expect(
        () => AortemCognitoAdminGetDeviceRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          deviceKey: 'us-west-2_deadbeef-dead-beef',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Bad deviceKey pattern
      expect(
        () => AortemCognitoAdminGetDeviceRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'user',
          deviceKey: 'invalid-key',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx response throws service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"ResourceNotFoundException"}';

      final req = AortemCognitoAdminGetDeviceRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'missing',
        deviceKey: 'us-west-2_deadbeef-dead-beef',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0,
      );

      expect(() => req.execute(), throwsA(isA<AortemCognitoServiceException>()));
    });
  });
}
