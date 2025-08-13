import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_forget_device_consumer.dart';
import 'package:test/test.dart';

// Adjust imports to your package paths.
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';

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
  group('AdminForgetDeviceConsumer (Ticket #20)', () {
    test('happy path: builds and sends payload', () async {
      final http = _FakeHttp();

      final consumer = AortemCognitoAdminForgetDeviceConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser')
          ..deviceKey('us-west-2_a1b2c3d4-5678-90ab-cdef-EXAMPLE22222'),
      );

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

    test('missing requireds throw before HTTP', () {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminForgetDeviceConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // Missing deviceKey
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..username('user'),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing username
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..deviceKey('us-west-2_a1b2-OK-123'),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing userPoolId
      expect(
        () => consumer.run(
          (b) => b
            ..username('user')
            ..deviceKey('us-west-2_a1b2-OK-123'),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
