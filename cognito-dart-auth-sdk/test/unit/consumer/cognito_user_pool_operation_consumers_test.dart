import 'package:cognito_dart_auth_sdk/consumers/cognito_user_pool_operation_consumers.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:test/test.dart';

class _FakeHttpClient implements CognitoHttpClient {
  String? target;
  Map<String, dynamic>? payload;

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

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    this.target = target;
    this.payload = payload;
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const <String, String>{},
      bodyString: '{"ok":true}',
    );
  }
}

void main() {
  group('Cognito user pool operation consumers', () {
    test('executes representative consumers through fluent builders', () async {
      final cases =
          <
            ({
              String operation,
              CognitoUserPoolOperationConsumer consumer,
              CognitoUserPoolOperationConsumerFn configure,
            })
          >[
            (
              operation: 'GetUser',
              consumer: CognitoGetUserConsumer(
                region: 'us-east-1',
                httpClient: _FakeHttpClient(),
              ),
              configure: (builder) => builder.accessToken('access-token'),
            ),
            (
              operation: 'InitiateAuth',
              consumer: CognitoInitiateAuthConsumer(
                region: 'us-east-1',
                httpClient: _FakeHttpClient(),
              ),
              configure: (builder) => builder
                ..authFlow('USER_PASSWORD_AUTH')
                ..clientId('client-1')
                ..authParameters(const {'USERNAME': 'alice'}),
            ),
            (
              operation: 'ListGroups',
              consumer: CognitoListGroupsPaginatorConsumer(
                region: 'us-east-1',
                httpClient: _FakeHttpClient(),
              ),
              configure: (builder) => builder
                ..userPoolId('us-east-1_EXAMPLE')
                ..limit(10)
                ..nextToken('next-token'),
            ),
            (
              operation: 'ListTagsForResource',
              consumer: CognitoListTagsForResourceConsumer(
                region: 'us-east-1',
                httpClient: _FakeHttpClient(),
              ),
              configure: (builder) => builder.resourceArn(
                'arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_EXAMPLE',
              ),
            ),
            (
              operation: 'RespondToAuthChallenge',
              consumer: CognitoRespondToAuthChallengeConsumer(
                region: 'us-east-1',
                httpClient: _FakeHttpClient(),
              ),
              configure: (builder) => builder
                ..challengeName('PASSWORD_VERIFIER')
                ..clientId('client-1')
                ..challengeResponses(const {'USERNAME': 'alice'}),
            ),
          ];

      for (final entry in cases) {
        final fake = entry.consumer.httpClient as _FakeHttpClient;
        final result = await entry.consumer.run(entry.configure);

        expect(result.success, isTrue, reason: entry.operation);
        expect(
          fake.target,
          'AWSCognitoIdentityProviderService.${entry.operation}',
          reason: entry.operation,
        );
      }
    });

    test('exposes Aortem consumer aliases', () async {
      final http = _FakeHttpClient();
      final consumer = AortemCognitoRevokeTokenConsumer(
        region: 'us-east-1',
        httpClient: http,
      );

      await consumer.run(
        (builder) => builder
          ..token('refresh-token')
          ..clientId('client-1'),
      );

      expect(http.target, 'AWSCognitoIdentityProviderService.RevokeToken');
      expect(http.payload, containsPair('ClientId', 'client-1'));
    });

    test('validates required builder values', () {
      final consumer = CognitoGetUserPoolMfaConfigConsumer(
        region: 'us-east-1',
        httpClient: _FakeHttpClient(),
      );

      expect(
        () => consumer.run((builder) {}),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
