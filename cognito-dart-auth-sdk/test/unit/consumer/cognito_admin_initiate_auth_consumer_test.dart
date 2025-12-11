import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_initiate_auth_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '''
{
  "AuthenticationResult": {
    "AccessToken": "A",
    "IdToken": "I",
    "RefreshToken": "R",
    "TokenType": "Bearer",
    "ExpiresIn": 3600
  }
}
''';

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
  group('AdminInitiateAuthConsumer (Ticket #26)', () {
    test('happy path: builds, sends, returns tokens', () async {
      final http = _FakeHttp();

      final consumer = CognitoAdminInitiateAuthConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..clientId('client123')
          ..authFlow('ADMIN_USER_PASSWORD_AUTH')
          ..authParameters({'USERNAME': 'testuser', 'PASSWORD': 'Secret!'})
          ..clientMetadata({'key': 'value'}),
      );

      expect(res.authenticationResult, isNotNull);
      expect(res.authenticationResult!.accessToken, 'A');

      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminInitiateAuth',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['ClientId'], 'client123');
      expect((p['AuthParameters'] as Map)['USERNAME'], 'testuser');
      expect((p['ClientMetadata'] as Map)['key'], 'value');
    });

    test('missing requireds throw before HTTP', () async {
      final http = _FakeHttp();

      final consumer = CognitoAdminInitiateAuthConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // missing clientId
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..authFlow('ADMIN_USER_PASSWORD_AUTH'),
        ),
        throwsA(isA<CognitoValidationException>()),
      );

      // missing pool id
      expect(
        () => consumer.run(
          (b) => b
            ..clientId('client123')
            ..authFlow('ADMIN_USER_PASSWORD_AUTH'),
        ),
        throwsA(isA<CognitoValidationException>()),
      );

      // missing flow
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..clientId('client123'),
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
