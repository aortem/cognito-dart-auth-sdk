import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
import 'package:test/test.dart';

class _FakeHttpClient implements CognitoHttpClient {
  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: '{}',
    );
  }

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) {
    return post(
      region: region,
      xAmzTarget: target,
      payload: payload,
      additionalHeaders: headers,
      timeout: timeout,
    );
  }
}

void main() {
  group('cognito_dart_auth_sdk public exports', () {
    test('exposes the primary SDK client and backwards-compatible alias', () {
      final client = Cognito(
        region: 'us-east-1',
        httpClient: _FakeHttpClient(),
      );
      final auth = CognitoAuth(
        region: 'us-east-1',
        httpClient: _FakeHttpClient(),
      );

      expect(client, isA<Cognito>());
      expect(auth, isA<Cognito>());
    });

    test(
      'exposes core HTTP and signer types from the package entrypoint',
      () async {
        final httpClient = CognitoSigV4HttpClient(
          ({required uri, required headers, required body, timeout}) async =>
              CognitoHttpResponse(
                statusCode: 200,
                headers: headers,
                bodyString: body,
              ),
          ({
            required region,
            required service,
            required method,
            required uri,
            required headers,
            required body,
          }) async => headers,
        );

        final response = await httpClient.post(
          region: 'us-east-1',
          xAmzTarget: 'AWSCognitoIdentityProviderService.SignUp',
          payload: const {'username': 'alice@example.com'},
        );

        expect(httpClient, isA<CognitoHttpClient>());
        expect(response.statusCode, 200);
        expect(
          response.jsonBody,
          containsPair('username', 'alice@example.com'),
        );
      },
    );

    test('exposes user pool operation request and consumer aliases', () {
      final httpClient = _FakeHttpClient();
      final request = AortemCognitoGetUserRequest(
        accessToken: 'access-token',
        region: 'us-east-1',
        httpClient: httpClient,
      );
      final consumer = AortemCognitoGetUserConsumer(
        region: 'us-east-1',
        httpClient: httpClient,
      );

      expect(request, isA<CognitoGetUserRequest>());
      expect(consumer, isA<CognitoGetUserConsumer>());
    });

    test('exposes additional user pool operation aliases', () {
      final httpClient = _FakeHttpClient();
      final request = AortemCognitoChangePasswordRequest(
        payload: const {
          'AccessToken': 'access-token',
          'PreviousPassword': 'OldPassword1!',
          'ProposedPassword': 'NewPassword1!',
        },
        region: 'us-east-1',
        httpClient: httpClient,
      );
      final consumer = AortemCognitoChangePasswordConsumer(
        region: 'us-east-1',
        httpClient: httpClient,
      );

      expect(request, isA<CognitoChangePasswordRequest>());
      expect(consumer, isA<CognitoChangePasswordConsumer>());
    });
  });
}
