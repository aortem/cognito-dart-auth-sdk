import 'package:test/test.dart';

// Adjust these imports to match your package name / paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_confirm_sign_up_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// Minimal fake HTTP client to capture payloads and control status codes.
class _FakeHttpClient implements AortemCognitoHttpClient {
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

  // If your interface also declares post(...), delegate it to send(...) to keep tests happy.
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
  group('AortemCognitoAdminConfirmSignUpRequest (simple)', () {
    test(
      'happy path: 200 OK returns result and sends expected payload',
      () async {
        final http = _FakeHttpClient();
        final req = AortemCognitoAdminConfirmSignUpRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'testuser',
          region: 'us-west-2',
          httpClient: http,
        );

        final res = await req.execute();
        expect(res, isA<AortemCognitoAdminConfirmSignUpResult>());

        // Verify payload + target
        final p = http.lastPayload!;
        expect(
          http.lastTarget,
          'AWSCognitoIdentityProviderService.AdminConfirmSignUp',
        );
        expect(http.lastRegion, 'us-west-2');
        expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

        expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
        expect(p['Username'], 'testuser');
        expect(p.containsKey('ClientMetadata'), isFalse);
      },
    );

    test('includes ClientMetadata when provided', () async {
      final http = _FakeHttpClient();
      final req = AortemCognitoAdminConfirmSignUpRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'user1',
        region: 'us-west-2',
        httpClient: http,
        clientMetadata: const {'source': 'admin-panel'},
      );

      await req.execute();
      final p = http.lastPayload!;
      expect(p['ClientMetadata'], {'source': 'admin-panel'});
    });

    test('validation: bad pool id pattern throws', () {
      final http = _FakeHttpClient();
      expect(
        () => AortemCognitoAdminConfirmSignUpRequest(
          userPoolId: 'badPoolId',
          username: 'user',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('validation: empty username throws', () {
      final http = _FakeHttpClient();
      expect(
        () => AortemCognitoAdminConfirmSignUpRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: '   ',
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx response throws AortemCognitoServiceException', () async {
      final http = _FakeHttpClient()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';

      final req = AortemCognitoAdminConfirmSignUpRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'user',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0, // fail fast
      );

      expect(
        () => req.execute(),
        throwsA(isA<AortemCognitoServiceException>()),
      );
    });
  });
}
