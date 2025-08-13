import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_disable_provider_for_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_disable_provider_for_user_request.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
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
  group('AdminDisableProviderForUserConsumer (Ticket #14)', () {
    test('happy path: builds and sends payload', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminDisableProviderForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..providerName('Cognito')
          ..providerAttributeName('Cognito_Subject')
          ..providerAttributeValue('testuser'),
      );

      expect(res, isA<AortemCognitoAdminDisableProviderForUserResult>());

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminDisableProviderForUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      final user = p['User'] as Map<String, dynamic>;
      expect(user['ProviderName'], 'Cognito');
      expect(user['ProviderAttributeName'], 'Cognito_Subject');
      expect(user['ProviderAttributeValue'], 'testuser');
    });

    test('missing requireds throw before HTTP', () {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminDisableProviderForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // Missing provider fields
      expect(
        () => consumer.run((b) => b..userPoolId('us-west-2_EXAMPLE')),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing pool id
      expect(
        () => consumer.run(
          (b) => b
            ..providerName('Cognito')
            ..providerAttributeName('Cognito_Subject')
            ..providerAttributeValue('user'),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
