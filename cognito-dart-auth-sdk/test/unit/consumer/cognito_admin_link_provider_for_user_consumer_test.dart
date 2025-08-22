import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_link_provider_for_user_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '{}';

  @override
  Future<CognitoHttpResponse> send({
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

    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  @override
  Future<CognitoHttpResponse> post({
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
  group('AdminLinkProviderForUserConsumer (Ticket #28)', () {
    test('happy path: builds and sends payload', () async {
      final http = _FakeHttp();

      final consumer = CognitoAdminLinkProviderForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..destinationUser(
            providerName: 'Cognito',
            providerAttributeValue: 'adminlink-testuser',
          )
          ..sourceUser(
            providerName: 'Google',
            providerAttributeName: 'Cognito_Subject',
            providerAttributeValue: '5432109876543210',
          ),
      );

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminLinkProviderForUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      final dest = p['DestinationUser'] as Map;
      expect(dest['ProviderName'], 'Cognito');
      expect(dest['ProviderAttributeValue'], 'adminlink-testuser');

      final src = p['SourceUser'] as Map;
      expect(src['ProviderName'], 'Google');
      expect(src['ProviderAttributeName'], 'Cognito_Subject');
      expect(src['ProviderAttributeValue'], '5432109876543210');
    });

    test('missing requireds throw before HTTP', () async {
      final http = _FakeHttp();
      final consumer = CognitoAdminLinkProviderForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // missing pool id
      expect(
        () => consumer.run(
          (b) => b
            ..destinationUser(
              providerName: 'Cognito',
              providerAttributeValue: 'u',
            )
            ..sourceUser(
              providerName: 'Facebook',
              providerAttributeName: 'Cognito_Subject',
              providerAttributeValue: 'id',
            ),
        ),
        throwsA(isA<CognitoValidationException>()),
      );

      // missing destination
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..sourceUser(
              providerName: 'Facebook',
              providerAttributeName: 'Cognito_Subject',
              providerAttributeValue: 'id',
            ),
        ),
        throwsA(isA<CognitoValidationException>()),
      );

      // missing source
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..destinationUser(
              providerName: 'Cognito',
              providerAttributeValue: 'u',
            ),
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
