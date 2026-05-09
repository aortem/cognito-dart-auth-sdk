import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_user_pool_operations.dart';
import 'package:test/test.dart';

class _FakeHttpClient implements CognitoHttpClient {
  String? target;
  String? region;
  Map<String, dynamic>? payload;
  int statusCode = 200;
  String bodyString = '{"ok":true}';

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
    this.region = region;
    this.payload = payload;
    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const <String, String>{},
      bodyString: bodyString,
    );
  }
}

void main() {
  group('Cognito user pool operation requests', () {
    test('wire each batch operation to the Cognito JSON API target', () async {
      final cases =
          <
            ({
              String operation,
              CognitoJsonOperationRequest Function(_FakeHttpClient http) create,
            })
          >[
            (
              operation: 'GetLogDeliveryConfiguration',
              create: (http) => CognitoGetLogDeliveryConfigurationRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GetSigningCertificate',
              create: (http) => CognitoGetSigningCertificateRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GetUICustomization',
              create: (http) => CognitoGetUICustomizationRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                clientId: 'client-1',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GetUser',
              create: (http) => CognitoGetUserRequest(
                accessToken: 'access-token',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GetUserAttributeVerificationCode',
              create: (http) => CognitoGetUserAttributeVerificationCodeRequest(
                accessToken: 'access-token',
                attributeName: 'email',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GetUserPoolMfaConfig',
              create: (http) => CognitoGetUserPoolMfaConfigRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'GlobalSignOut',
              create: (http) => CognitoGlobalSignOutRequest(
                accessToken: 'access-token',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'InitiateAuth',
              create: (http) => CognitoInitiateAuthRequest(
                authFlow: 'USER_PASSWORD_AUTH',
                clientId: 'client-1',
                authParameters: const {'USERNAME': 'alice'},
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListDevices',
              create: (http) => CognitoListDevicesRequest(
                accessToken: 'access-token',
                limit: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListGroups',
              create: (http) => CognitoListGroupsRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                limit: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListIdentityProviders',
              create: (http) => CognitoListIdentityProvidersRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                maxResults: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListResourceServers',
              create: (http) => CognitoListResourceServersRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                maxResults: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListTagsForResource',
              create: (http) => CognitoListTagsForResourceRequest(
                resourceArn:
                    'arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_EXAMPLE',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListUserImportJobs',
              create: (http) => CognitoListUserImportJobsRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                maxResults: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListUserPoolClients',
              create: (http) => CognitoListUserPoolClientsRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                maxResults: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListUserPools',
              create: (http) => CognitoListUserPoolsRequest(
                maxResults: 10,
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ListUsers',
              create: (http) => CognitoListUsersRequest(
                userPoolId: 'us-east-1_EXAMPLE',
                attributesToGet: const ['email'],
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'ResendConfirmationCode',
              create: (http) => CognitoResendConfirmationCodeRequest(
                clientId: 'client-1',
                username: 'alice',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'RespondToAuthChallenge',
              create: (http) => CognitoRespondToAuthChallengeRequest(
                challengeName: 'PASSWORD_VERIFIER',
                clientId: 'client-1',
                challengeResponses: const {'USERNAME': 'alice'},
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
            (
              operation: 'RevokeToken',
              create: (http) => CognitoRevokeTokenRequest(
                token: 'refresh-token',
                clientId: 'client-1',
                region: 'us-east-1',
                httpClient: http,
              ),
            ),
          ];

      for (final entry in cases) {
        final http = _FakeHttpClient();
        final result = await entry.create(http).execute();

        expect(result.success, isTrue, reason: entry.operation);
        expect(
          http.target,
          'AWSCognitoIdentityProviderService.${entry.operation}',
          reason: entry.operation,
        );
        expect(http.region, 'us-east-1', reason: entry.operation);
      }
    });

    test('exposes Aortem request aliases for duplicate ticket names', () async {
      final http = _FakeHttpClient();
      final request = AortemCognitoListUsersPaginatorRequest(
        userPoolId: 'us-east-1_EXAMPLE',
        paginationToken: 'next',
        region: 'us-east-1',
        httpClient: http,
      );

      await request.execute();

      expect(http.target, 'AWSCognitoIdentityProviderService.ListUsers');
      expect(http.payload, containsPair('PaginationToken', 'next'));
    });

    test('rejects missing required input before making a request', () {
      expect(
        () => CognitoGetUserRequest(
          accessToken: ' ',
          region: 'us-east-1',
          httpClient: _FakeHttpClient(),
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });

    test('throws service exception for Cognito client errors', () {
      final http = _FakeHttpClient()
        ..statusCode = 400
        ..bodyString = '{"__type":"InvalidParameterException"}';
      final request = CognitoRevokeTokenRequest(
        token: 'refresh-token',
        clientId: 'client-1',
        region: 'us-east-1',
        httpClient: http,
        maxRetries: 0,
      );

      expect(request.execute, throwsA(isA<CognitoServiceException>()));
    });
  });
}
