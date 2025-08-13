import 'package:test/test.dart';

// Adjust imports to your package paths.
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_disable_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

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
  group('AdminDisableProviderForUserRequest (Ticket #13)', () {
    test('happy path: 200 OK returns empty-success result', () async {
      final http = _FakeHttp();
      final req = AortemCognitoAdminDisableProviderForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        user: const AortemCognitoProviderUserIdentifier(
          providerName: 'Cognito',
          providerAttributeName: 'Cognito_Subject',
          providerAttributeValue: 'testuser',
        ),
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<AortemCognitoAdminDisableProviderForUserResult>());

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminDisableProviderForUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      final u = p['User'] as Map<String, dynamic>;
      expect(u['ProviderName'], 'Cognito');
      expect(u['ProviderAttributeName'], 'Cognito_Subject');
      expect(u['ProviderAttributeValue'], 'testuser');
    });

    test('validation: bad pool id throws', () {
      final http = _FakeHttp();
      expect(
        () => AortemCognitoAdminDisableProviderForUserRequest(
          userPoolId: 'badPoolId',
          user: const AortemCognitoProviderUserIdentifier(
            providerName: 'Cognito',
            providerAttributeName: 'Cognito_Subject',
            providerAttributeValue: 'user',
          ),
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

      final req = AortemCognitoAdminDisableProviderForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        user: const AortemCognitoProviderUserIdentifier(
          providerName: 'Google',
          providerAttributeName: 'Cognito_Subject',
          providerAttributeValue: 'google-subject-123',
        ),
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
