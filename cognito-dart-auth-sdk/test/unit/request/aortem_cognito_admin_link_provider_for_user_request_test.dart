import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_link_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

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
  group('AdminLinkProviderForUserRequest (Ticket #27)', () {
    test('happy path: 200 returns empty-success', () async {
      final http = _FakeHttp();

      final req = AortemCognitoAdminLinkProviderForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        destinationUser: const AortemCognitoProviderUserLinkingIdentifier(
          providerName: 'Cognito',
          providerAttributeValue: 'adminlink-testuser',
        ),
        sourceUser: const AortemCognitoProviderUserLinkingIdentifier(
          providerName: 'Google',
          providerAttributeName: 'Cognito_Subject',
          providerAttributeValue: '5432109876543210',
        ),
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res, isA<AortemCognitoAdminLinkProviderForUserResult>());

      // wiring assertions
      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminLinkProviderForUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');

      final dest = p['DestinationUser'] as Map;
      expect(dest['ProviderName'], 'Cognito');
      expect(dest['ProviderAttributeValue'], 'adminlink-testuser');

      final src = p['SourceUser'] as Map;
      expect(src['ProviderName'], 'Google');
      expect(src['ProviderAttributeName'], 'Cognito_Subject');
      expect(src['ProviderAttributeValue'], '5432109876543210');
    });

    test('validation: bad pool id & missing users', () {
      final http = _FakeHttp();

      // bad pool id
      expect(
        () => AortemCognitoAdminLinkProviderForUserRequest(
          userPoolId: 'bad',
          destinationUser: const AortemCognitoProviderUserLinkingIdentifier(
            providerName: 'Cognito',
            providerAttributeValue: 'admin',
          ),
          sourceUser: const AortemCognitoProviderUserLinkingIdentifier(
            providerName: 'Google',
            providerAttributeName: 'Cognito_Subject',
            providerAttributeValue: 'id',
          ),
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // missing destination/source via consumer-level checks are in consumer tests
    });

    test('4xx throws service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"ResourceNotFoundException"}';

      final req = AortemCognitoAdminLinkProviderForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        destinationUser: const AortemCognitoProviderUserLinkingIdentifier(
          providerName: 'Cognito',
          providerAttributeValue: 'adminlink-testuser',
        ),
        sourceUser: const AortemCognitoProviderUserLinkingIdentifier(
          providerName: 'Facebook',
          providerAttributeName: 'Cognito_Subject',
          providerAttributeValue: '1234567890',
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
