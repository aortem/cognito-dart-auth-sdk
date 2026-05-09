import 'package:cognito_dart_auth_sdk/consumers/cognito_additional_user_pool_operation_consumers.dart';
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
  const payload = <String, Object?>{
    'AccessToken': 'access-token',
    'ClientId': 'client-1',
    'ClientName': 'client-name',
    'CloudWatchLogsRoleArn': 'arn:aws:iam::123456789012:role/cognito-import',
    'ConfirmationCode': '123456',
    'Credential': {'id': 'credential'},
    'CredentialId': 'credential-id',
    'DeviceKey': 'device-key',
    'Domain': 'auth-example',
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
    'UserAttributeNames': ['email'],
    'Username': 'alice',
    'UserPoolId': 'us-east-1_EXAMPLE',
  };

  CognitoConfiguredUserPoolOperationConsumer build(
    String operation,
    _FakeHttpClient http,
  ) {
    switch (operation) {
      case 'AdminUserGlobalSignOut':
        return CognitoAdminUserGlobalSignOutConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'AssociateSoftwareToken':
        return CognitoAssociateSoftwareTokenConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ChangePassword':
        return CognitoChangePasswordConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CompleteWebAuthnRegistration':
        return CognitoCompleteWebAuthnRegistrationConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ConfirmDevice':
        return CognitoConfirmDeviceConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ConfirmForgotPassword':
        return CognitoConfirmForgotPasswordConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateGroup':
        return CognitoCreateGroupConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateIdentityProvider':
        return CognitoCreateIdentityProviderConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateManagedLoginBranding':
        return CognitoCreateManagedLoginBrandingConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateResourceServer':
        return CognitoCreateResourceServerConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserImportJob':
        return CognitoCreateUserImportJobConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPool':
        return CognitoCreateUserPoolConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPoolClient':
        return CognitoCreateUserPoolClientConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'CreateUserPoolDomain':
        return CognitoCreateUserPoolDomainConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteGroup':
        return CognitoDeleteGroupConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteIdentityProvider':
        return CognitoDeleteIdentityProviderConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteManagedLoginBranding':
        return CognitoDeleteManagedLoginBrandingConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteResourceServer':
        return CognitoDeleteResourceServerConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUser':
        return CognitoDeleteUserConsumer(region: 'us-east-1', httpClient: http);
      case 'DeleteUserAttributes':
        return CognitoDeleteUserAttributesConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPool':
        return CognitoDeleteUserPoolConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPoolClient':
        return CognitoDeleteUserPoolClientConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteUserPoolDomain':
        return CognitoDeleteUserPoolDomainConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DeleteWebAuthnCredential':
        return CognitoDeleteWebAuthnCredentialConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeIdentityProvider':
        return CognitoDescribeIdentityProviderConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeManagedLoginBranding':
        return CognitoDescribeManagedLoginBrandingConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeManagedLoginBrandingByClient':
        return CognitoDescribeManagedLoginBrandingByClientConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeResourceServer':
        return CognitoDescribeResourceServerConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeRiskConfiguration':
        return CognitoDescribeRiskConfigurationConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserImportJob':
        return CognitoDescribeUserImportJobConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserPool':
        return CognitoDescribeUserPoolConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'DescribeUserPoolDomain':
        return CognitoDescribeUserPoolDomainConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ForgetDevice':
        return CognitoForgetDeviceConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'ForgotPassword':
        return CognitoForgotPasswordConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetCSVHeader':
        return CognitoGetCSVHeaderConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'GetDevice':
        return CognitoGetDeviceConsumer(region: 'us-east-1', httpClient: http);
      case 'GetGroup':
        return CognitoGetGroupConsumer(region: 'us-east-1', httpClient: http);
      case 'GetIdentityProviderByIdentifier':
        return CognitoGetIdentityProviderByIdentifierConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetLogDeliveryConfiguration':
        return CognitoSetLogDeliveryConfigurationConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetRiskConfiguration':
        return CognitoSetRiskConfigurationConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUICustomization':
        return CognitoSetUICustomizationConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUserMFAPreference':
        return CognitoSetUserMFAPreferenceConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      case 'SetUserPoolMfaConfig':
        return CognitoSetUserPoolMfaConfigConsumer(
          region: 'us-east-1',
          httpClient: http,
        );
      default:
        throw ArgumentError.value(operation, 'operation');
    }
  }

  group('additional Cognito user pool operation consumers', () {
    test('wire each older open ticket operation through the builder', () async {
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
      ];

      for (final operation in operations) {
        final http = _FakeHttpClient();
        final result = await build(
          operation,
          http,
        ).run((builder) => builder.fields(payload));

        expect(result.success, isTrue, reason: operation);
        expect(
          http.target,
          'AWSCognitoIdentityProviderService.$operation',
          reason: operation,
        );
      }
    });

    test('exposes Aortem aliases for additional consumers', () async {
      final http = _FakeHttpClient();
      final consumer = AortemCognitoSetUserPoolMfaConfigConsumer(
        region: 'us-east-1',
        httpClient: http,
      );

      await consumer.run((builder) => builder.userPoolId('us-east-1_EXAMPLE'));

      expect(
        http.target,
        'AWSCognitoIdentityProviderService.SetUserPoolMfaConfig',
      );
    });
  });
}
