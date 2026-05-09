import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_additional_user_pool_operations.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_user_pool_operations.dart';
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
  const commonPayload = <String, dynamic>{
    'AccessToken': 'access-token',
    'AttributeName': 'email',
    'ClientId': 'client-1',
    'ClientName': 'client-name',
    'CloudWatchLogsRoleArn': 'arn:aws:iam::123456789012:role/cognito-import',
    'ConfirmationCode': '123456',
    'Credential': {'id': 'credential'},
    'CredentialId': 'credential-id',
    'DeviceKey': 'device-key',
    'Domain': 'auth-example',
    'EventId': 'event-id',
    'FeedbackToken': 'feedback-token',
    'FeedbackValue': 'Valid',
    'GroupName': 'group-name',
    'Identifier': 'resource-server',
    'IdpIdentifier': 'idp-identifier',
    'JobId': 'job-id',
    'JobName': 'job-name',
    'LogConfigurations': [
      {'EventSource': 'userNotification'},
    ],
    'ManagedLoginBrandingId': 'branding-id',
    'Name': 'display-name',
    'Password': 'Password1!',
    'PoolName': 'pool-name',
    'PreviousPassword': 'OldPassword1!',
    'ProposedPassword': 'NewPassword1!',
    'ProviderDetails': {'client_id': 'provider-client'},
    'ProviderName': 'Google',
    'ProviderType': 'Google',
    'ResourceArn':
        'arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_EXAMPLE',
    'Tags': {'env': 'test'},
    'TagKeys': ['env'],
    'UserAttributeNames': ['email'],
    'UserAttributes': [
      {'Name': 'email', 'Value': 'alice@example.com'},
    ],
    'UserCode': '123456',
    'Username': 'alice',
    'UserPoolId': 'us-east-1_EXAMPLE',
    'Code': '123456',
  };

  CognitoConfiguredUserPoolOperationRequest build(
    String operation,
    Map<String, dynamic> payload,
    _FakeHttpClient http,
  ) {
    switch (operation) {
      case 'AdminUserGlobalSignOut':
        return CognitoAdminUserGlobalSignOutRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'AssociateSoftwareToken':
        return CognitoAssociateSoftwareTokenRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ChangePassword':
        return CognitoChangePasswordRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CompleteWebAuthnRegistration':
        return CognitoCompleteWebAuthnRegistrationRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ConfirmDevice':
        return CognitoConfirmDeviceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ConfirmForgotPassword':
        return CognitoConfirmForgotPasswordRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateGroup':
        return CognitoCreateGroupRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateIdentityProvider':
        return CognitoCreateIdentityProviderRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateManagedLoginBranding':
        return CognitoCreateManagedLoginBrandingRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateResourceServer':
        return CognitoCreateResourceServerRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserImportJob':
        return CognitoCreateUserImportJobRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPool':
        return CognitoCreateUserPoolRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPoolClient':
        return CognitoCreateUserPoolClientRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPoolDomain':
        return CognitoCreateUserPoolDomainRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteGroup':
        return CognitoDeleteGroupRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteIdentityProvider':
        return CognitoDeleteIdentityProviderRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteManagedLoginBranding':
        return CognitoDeleteManagedLoginBrandingRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteResourceServer':
        return CognitoDeleteResourceServerRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUser':
        return CognitoDeleteUserRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserAttributes':
        return CognitoDeleteUserAttributesRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPool':
        return CognitoDeleteUserPoolRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPoolClient':
        return CognitoDeleteUserPoolClientRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPoolDomain':
        return CognitoDeleteUserPoolDomainRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteWebAuthnCredential':
        return CognitoDeleteWebAuthnCredentialRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeIdentityProvider':
        return CognitoDescribeIdentityProviderRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeManagedLoginBranding':
        return CognitoDescribeManagedLoginBrandingRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeManagedLoginBrandingByClient':
        return CognitoDescribeManagedLoginBrandingByClientRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeResourceServer':
        return CognitoDescribeResourceServerRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeRiskConfiguration':
        return CognitoDescribeRiskConfigurationRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserImportJob':
        return CognitoDescribeUserImportJobRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserPool':
        return CognitoDescribeUserPoolRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserPoolDomain':
        return CognitoDescribeUserPoolDomainRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ForgetDevice':
        return CognitoForgetDeviceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ForgotPassword':
        return CognitoForgotPasswordRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetCSVHeader':
        return CognitoGetCSVHeaderRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetDevice':
        return CognitoGetDeviceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetGroup':
        return CognitoGetGroupRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetIdentityProviderByIdentifier':
        return CognitoGetIdentityProviderByIdentifierRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetLogDeliveryConfiguration':
        return CognitoSetLogDeliveryConfigurationRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetRiskConfiguration':
        return CognitoSetRiskConfigurationRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUICustomization':
        return CognitoSetUICustomizationRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUserMFAPreference':
        return CognitoSetUserMFAPreferenceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUserPoolMfaConfig':
        return CognitoSetUserPoolMfaConfigRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUserSettings':
        return CognitoSetUserSettingsRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'StartUserImportJob':
        return CognitoStartUserImportJobRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'StopUserImportJob':
        return CognitoStopUserImportJobRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'TagResource':
        return CognitoTagResourceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UntagResource':
        return CognitoUntagResourceRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateAuthEventFeedback':
        return CognitoUpdateAuthEventFeedbackRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateDeviceStatus':
        return CognitoUpdateDeviceStatusRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateGroup':
        return CognitoUpdateGroupRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateIdentityProvider':
        return CognitoUpdateIdentityProviderRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateManagedLoginBranding':
        return CognitoUpdateManagedLoginBrandingRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateResourceServer':
        return CognitoUpdateResourceServerRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateUserAttributes':
        return CognitoUpdateUserAttributesRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateUserPool':
        return CognitoUpdateUserPoolRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateUserPoolClient':
        return CognitoUpdateUserPoolClientRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'UpdateUserPoolDomain':
        return CognitoUpdateUserPoolDomainRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'VerifySoftwareToken':
        return CognitoVerifySoftwareTokenRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      case 'VerifyUserAttribute':
        return CognitoVerifyUserAttributeRequest(
          payload: payload,
          region: 'us-east-1',
          httpClient: http,
        );
      default:
        throw ArgumentError.value(operation, 'operation');
    }
  }

  group('additional Cognito user pool operation requests', () {
    test(
      'wire each older open ticket operation to the Cognito JSON API',
      () async {
        const operations = <String>[
          'AdminUserGlobalSignOut',
          'AssociateSoftwareToken',
          'ChangePassword',
          'CompleteWebAuthnRegistration',
          'ConfirmDevice',
          'ConfirmForgotPassword',
          'CreateGroup',
          'CreateIdentityProvider',
          'CreateManagedLoginBranding',
          'CreateResourceServer',
          'CreateUserImportJob',
          'CreateUserPool',
          'CreateUserPoolClient',
          'CreateUserPoolDomain',
          'DeleteGroup',
          'DeleteIdentityProvider',
          'DeleteManagedLoginBranding',
          'DeleteResourceServer',
          'DeleteUser',
          'DeleteUserAttributes',
          'DeleteUserPool',
          'DeleteUserPoolClient',
          'DeleteUserPoolDomain',
          'DeleteWebAuthnCredential',
          'DescribeIdentityProvider',
          'DescribeManagedLoginBranding',
          'DescribeManagedLoginBrandingByClient',
          'DescribeResourceServer',
          'DescribeRiskConfiguration',
          'DescribeUserImportJob',
          'DescribeUserPool',
          'DescribeUserPoolDomain',
          'ForgetDevice',
          'ForgotPassword',
          'GetCSVHeader',
          'GetDevice',
          'GetGroup',
          'GetIdentityProviderByIdentifier',
          'SetLogDeliveryConfiguration',
          'SetRiskConfiguration',
          'SetUICustomization',
          'SetUserMFAPreference',
          'SetUserPoolMfaConfig',
          'SetUserSettings',
          'StartUserImportJob',
          'StopUserImportJob',
          'TagResource',
          'UntagResource',
          'UpdateAuthEventFeedback',
          'UpdateDeviceStatus',
          'UpdateGroup',
          'UpdateIdentityProvider',
          'UpdateManagedLoginBranding',
          'UpdateResourceServer',
          'UpdateUserAttributes',
          'UpdateUserPool',
          'UpdateUserPoolClient',
          'UpdateUserPoolDomain',
          'VerifySoftwareToken',
          'VerifyUserAttribute',
        ];

        for (final operation in operations) {
          final http = _FakeHttpClient();
          final result = await build(operation, commonPayload, http).execute();

          expect(result.success, isTrue, reason: operation);
          expect(
            http.target,
            'AWSCognitoIdentityProviderService.$operation',
            reason: operation,
          );
        }
      },
    );

    test('exposes Aortem aliases for additional request names', () async {
      final http = _FakeHttpClient();
      final request = AortemCognitoSetLogDeliveryConfigurationRequest(
        payload: commonPayload,
        region: 'us-east-1',
        httpClient: http,
      );

      await request.execute();

      expect(
        http.target,
        'AWSCognitoIdentityProviderService.SetLogDeliveryConfiguration',
      );
    });

    test('validates required list fields', () {
      expect(
        () => CognitoDeleteUserAttributesRequest(
          payload: const {'AccessToken': 'access-token'},
          region: 'us-east-1',
          httpClient: _FakeHttpClient(),
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
