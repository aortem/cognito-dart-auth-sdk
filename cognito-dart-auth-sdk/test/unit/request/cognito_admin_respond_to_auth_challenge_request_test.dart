import 'dart:convert';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_respond_to_auth_challenge_request.dart';

class _FakeHttpClient implements CognitoHttpClient {
  String? lastService;
  String? lastTarget;
  String? lastRegion;
  Map<String, dynamic>? lastPayload;
  Map<String, String>? lastHeaders;
  Duration? lastTimeout;

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastService = service;
    lastTarget = target;
    lastRegion = region;
    lastPayload = payload;
    lastHeaders = headers;
    lastTimeout = timeout;

    // Return a realistic AuthenticationResult wrapper.
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'AuthenticationResult': {
          'AccessToken': 'access',
          'IdToken': 'id',
          'RefreshToken': 'refresh',
          'ExpiresIn': 3600,
          'TokenType': 'Bearer',
        },
        'ChallengeParameters': {},
      }),
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
  test(
    'Request.execute sends proper target/payload and returns body',
    () async {
      final fake = _FakeHttpClient();

      final req = CognitoAdminRespondToAuthChallengeRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        clientId: '1example23456789',
        challengeName: 'SOFTWARE_TOKEN_MFA',
        challengeResponses: const {
          'USERNAME': 'testuser',
          'SOFTWARE_TOKEN_MFA_CODE': '123456',
          'SECRET_HASH': 'abc=',
        },
        clientMetadata: const {'k': 'v'},
        analyticsMetadata: const {'AnalyticsEndpointId': 'endpoint-1'},
        contextData: const {
          'IpAddress': '192.0.2.1',
          'ServerName': 'auth.example.com',
          'ServerPath': '/login',
          'EncodedData': 'ABC',
          'HttpHeaders': [
            {'headerName': 'Referer', 'headerValue': 'https://example.com'},
          ],
        },
        session: 'X' * 25,
        region: 'us-west-2',
        httpClient: fake,
      );

      final res = await req.execute();

      expect(res.statusCode, 200);
      expect(res.body, contains('AuthenticationResult'));

      expect(fake.lastService, 'cognito-idp');
      expect(
        fake.lastTarget,
        'AWSCognitoIdentityProviderService.AdminRespondToAuthChallenge',
      );
      expect(fake.lastRegion, 'us-west-2');
      expect(fake.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      final p = fake.lastPayload!;
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['ClientId'], '1example23456789');
      expect(p['ChallengeName'], 'SOFTWARE_TOKEN_MFA');
      expect(p['ChallengeResponses'], {
        'USERNAME': 'testuser',
        'SOFTWARE_TOKEN_MFA_CODE': '123456',
        'SECRET_HASH': 'abc=',
      });
      expect(p['ClientMetadata'], {'k': 'v'});
      expect(p['AnalyticsMetadata'], {'AnalyticsEndpointId': 'endpoint-1'});
      expect(p['ContextData'], isA<Map>());
      expect(p['Session'], isA<String>());
      expect(fake.lastTimeout, isNotNull);
    },
  );
}
