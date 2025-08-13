import 'package:test/test.dart';

// Adjust imports to your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '{}';

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
  group('AdminForgetDeviceRequest (Ticket #19)', () {
    test('happy path: 200 OK returns empty-success result', () async {
      final http = _FakeHttp();

      final req = AortemCognitoAdminForgetDeviceRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        deviceKey: 'us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222',
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<AortemCognitoAdminForgetDeviceResult>());

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminForgetDevice',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['DeviceKey'], 'us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222');
    });

    test('validation: bad pool id throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminForgetDeviceRequest(
          userPoolId: 'badPoolId',
          username: 'user',
          deviceKey: 'us-west-2_a1b2-OK-123',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('validation: empty username throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminForgetDeviceRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          deviceKey: 'us-west-2_a1b2-OK-123',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('validation: bad deviceKey pattern throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminForgetDeviceRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'user',
          deviceKey: 'not-valid-key',
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

      final req = AortemCognitoAdminForgetDeviceRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'missing',
        deviceKey: 'us-west-2_deadbeef-dead-beef-beef-EXAMPLE',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0,
      );

      expect(
        () => req.execute(),
        throwsA(isA<AortemCognitoServiceException>()),
      );
    });
  });
}
