import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_initiate_auth_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '''
{
  "AuthenticationResult": {
    "AccessToken": "AT",
    "IdToken": "IT",
    "RefreshToken": "RT",
    "TokenType": "Bearer",
    "ExpiresIn": 3600,
    "NewDeviceMetadata": {
      "DeviceGroupKey": "DGK",
      "DeviceKey": "DK"
    }
  },
  "ChallengeParameters": {}
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
  group('AdminInitiateAuthRequest (Ticket #25)', () {
    test('happy path: returns AuthenticationResult tokens', () async {
      final http = _FakeHttp();

      final req = AortemCognitoAdminInitiateAuthRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        clientId: '1example23456789',
        authFlow: 'ADMIN_USER_PASSWORD_AUTH',
        authParameters: const {'USERNAME': 'testuser', 'PASSWORD': 'Secret!'},
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();

      // wiring
      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminInitiateAuth',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['ClientId'], '1example23456789');
      expect(p['AuthFlow'], 'ADMIN_USER_PASSWORD_AUTH');
      expect((p['AuthParameters'] as Map)['USERNAME'], 'testuser');

      // parsed
      expect(res.authenticationResult, isNotNull);
      expect(res.authenticationResult!.accessToken, 'AT');
      expect(res.authenticationResult!.idToken, 'IT');
      expect(res.authenticationResult!.refreshToken, 'RT');
      expect(res.authenticationResult!.tokenType, 'Bearer');
      expect(res.authenticationResult!.expiresIn, 3600);
      expect(res.authenticationResult!.newDeviceKey, 'DK');
      expect(res.authenticationResult!.newDeviceGroupKey, 'DGK');

      // no challenge in this happy path
      expect(res.challengeName, isNull);
      expect(res.session, isNull);
    });

    test('challenge path: returns ChallengeName and Session', () async {
      final http = _FakeHttp()
        ..bodyString = '''
{
  "ChallengeName": "NEW_PASSWORD_REQUIRED",
  "ChallengeParameters": {"USER_ID_FOR_SRP":"user123"},
  "Session": "session-abc"
}
''';

      final req = AortemCognitoAdminInitiateAuthRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        clientId: '1example23456789',
        authFlow: 'ADMIN_USER_PASSWORD_AUTH',
        authParameters: const {'USERNAME': 'testuser', 'PASSWORD': 'Secret!'},
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await req.execute();
      expect(res.authenticationResult, isNull);
      expect(res.challengeName, 'NEW_PASSWORD_REQUIRED');
      expect(res.session, 'session-abc');
      expect(res.challengeParameters['USER_ID_FOR_SRP'], 'user123');
    });

    test('validation errors: bad pool/client/flow', () {
      final http = _FakeHttp();

      // bad pool id
      expect(
        () => AortemCognitoAdminInitiateAuthRequest(
          userPoolId: 'badPool',
          clientId: 'client123',
          authFlow: 'ADMIN_USER_PASSWORD_AUTH',
          authParameters: const {},
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // bad client id (invalid chars)
      expect(
        () => AortemCognitoAdminInitiateAuthRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          clientId: 'bad id!',
          authFlow: 'ADMIN_USER_PASSWORD_AUTH',
          authParameters: const {},
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // unsupported flow
      expect(
        () => AortemCognitoAdminInitiateAuthRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          clientId: 'client123',
          authFlow:
              'USER_PASSWORD_AUTH', // not valid for AdminInitiateAuth generally
          authParameters: const {},
          region: 'us-west-2',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx response throws service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"NotAuthorizedException"}';

      final req = AortemCognitoAdminInitiateAuthRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        clientId: 'client123',
        authFlow: 'ADMIN_USER_PASSWORD_AUTH',
        authParameters: const {'USERNAME': 'bad', 'PASSWORD': 'wrong'},
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
