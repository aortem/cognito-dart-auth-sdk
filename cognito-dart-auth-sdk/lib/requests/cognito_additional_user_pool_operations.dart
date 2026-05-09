// ignore_for_file: type_init_formals, use_super_parameters

import 'package:cognito_dart_auth_sdk/requests/cognito_confirm_signup_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_sign_up_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_user_pool_operations.dart';

abstract class CognitoConfiguredUserPoolOperationRequest
    extends CognitoGenericUserPoolOperationRequest {
  CognitoConfiguredUserPoolOperationRequest({
    required super.operation,
    required Map<String, dynamic> super.payload,
    required super.region,
    required super.httpClient,
    super.requiredStrings,
    super.requiredMaps,
    super.requiredInts,
    super.requiredLists,
    super.optionalLimits,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoAdminUserGlobalSignOutRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoAdminUserGlobalSignOutRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'AdminUserGlobalSignOut',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Username'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoAssociateSoftwareTokenRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoAssociateSoftwareTokenRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'AssociateSoftwareToken',
         payload: payload,
         region: region,
         httpClient: httpClient,
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoChangePasswordRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoChangePasswordRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ChangePassword',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const [
           'PreviousPassword',
           'ProposedPassword',
           'AccessToken',
         ],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCompleteWebAuthnRegistrationRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCompleteWebAuthnRegistrationRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CompleteWebAuthnRegistration',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         requiredMaps: const ['Credential'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoConfirmDeviceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoConfirmDeviceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ConfirmDevice',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoConfirmForgotPasswordRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoConfirmForgotPasswordRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ConfirmForgotPassword',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const [
           'ClientId',
           'Username',
           'ConfirmationCode',
           'Password',
         ],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateGroupRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateGroupRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateGroup',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateIdentityProviderRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateIdentityProviderRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateIdentityProvider',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName', 'ProviderType'],
         requiredMaps: const ['ProviderDetails'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateManagedLoginBrandingRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateManagedLoginBrandingRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateManagedLoginBranding',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateResourceServerRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateResourceServerRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateResourceServer',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier', 'Name'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserImportJobRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateUserImportJobRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserImportJob',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const [
           'UserPoolId',
           'JobName',
           'CloudWatchLogsRoleArn',
         ],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserPoolRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateUserPoolRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPool',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['PoolName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserPoolClientRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateUserPoolClientRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPoolClient',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserPoolDomainRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoCreateUserPoolDomainRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPoolDomain',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain', 'UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteGroupRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteGroupRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteGroup',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteIdentityProviderRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteIdentityProviderRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteIdentityProvider',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteManagedLoginBrandingRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteManagedLoginBrandingRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteManagedLoginBranding',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ManagedLoginBrandingId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteResourceServerRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteResourceServerRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteResourceServer',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteUserRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUser',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserAttributesRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteUserAttributesRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserAttributes',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         requiredLists: const ['UserAttributeNames'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteUserPoolRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPool',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolClientRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteUserPoolClientRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPoolClient',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolDomainRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteUserPoolDomainRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPoolDomain',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain', 'UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteWebAuthnCredentialRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDeleteWebAuthnCredentialRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteWebAuthnCredential',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'CredentialId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeIdentityProviderRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeIdentityProviderRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeIdentityProvider',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeManagedLoginBrandingRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeManagedLoginBrandingRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeManagedLoginBranding',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ManagedLoginBrandingId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeManagedLoginBrandingByClientRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeManagedLoginBrandingByClientRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeManagedLoginBrandingByClient',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeResourceServerRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeResourceServerRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeResourceServer',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeRiskConfigurationRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeRiskConfigurationRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeRiskConfiguration',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserImportJobRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeUserImportJobRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserImportJob',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'JobId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserPoolRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeUserPoolRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserPool',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserPoolDomainRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoDescribeUserPoolDomainRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserPoolDomain',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoForgetDeviceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoForgetDeviceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ForgetDevice',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoForgotPasswordRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoForgotPasswordRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ForgotPassword',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ClientId', 'Username'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetCSVHeaderRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoGetCSVHeaderRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetCSVHeader',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetDeviceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoGetDeviceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetDevice',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetGroupRequest extends CognitoConfiguredUserPoolOperationRequest {
  CognitoGetGroupRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetGroup',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetIdentityProviderByIdentifierRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoGetIdentityProviderByIdentifierRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetIdentityProviderByIdentifier',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'IdpIdentifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetLogDeliveryConfigurationRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetLogDeliveryConfigurationRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetLogDeliveryConfiguration',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         requiredLists: const ['LogConfigurations'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetRiskConfigurationRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetRiskConfigurationRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetRiskConfiguration',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUICustomizationRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetUICustomizationRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUICustomization',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUserMFAPreferenceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetUserMFAPreferenceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUserMFAPreference',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUserPoolMfaConfigRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetUserPoolMfaConfigRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUserPoolMfaConfig',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUserSettingsRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoSetUserSettingsRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUserSettings',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoStartUserImportJobRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoStartUserImportJobRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'StartUserImportJob',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'JobId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoStopUserImportJobRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoStopUserImportJobRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'StopUserImportJob',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'JobId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoTagResourceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoTagResourceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'TagResource',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ResourceArn'],
         requiredMaps: const ['Tags'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUntagResourceRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUntagResourceRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UntagResource',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ResourceArn'],
         requiredLists: const ['TagKeys'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateAuthEventFeedbackRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateAuthEventFeedbackRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateAuthEventFeedback',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const [
           'UserPoolId',
           'Username',
           'EventId',
           'FeedbackToken',
           'FeedbackValue',
         ],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateDeviceStatusRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateDeviceStatusRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateDeviceStatus',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateGroupRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateGroupRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateGroup',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateIdentityProviderRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateIdentityProviderRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateIdentityProvider',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName'],
         requiredMaps: const ['ProviderDetails'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateManagedLoginBrandingRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateManagedLoginBrandingRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateManagedLoginBranding',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ManagedLoginBrandingId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateResourceServerRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateResourceServerRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateResourceServer',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier', 'Name'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateUserAttributesRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateUserAttributesRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateUserAttributes',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         requiredLists: const ['UserAttributes'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateUserPoolRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateUserPoolRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateUserPool',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateUserPoolClientRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateUserPoolClientRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateUserPoolClient',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoUpdateUserPoolDomainRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoUpdateUserPoolDomainRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'UpdateUserPoolDomain',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain', 'UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoVerifySoftwareTokenRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoVerifySoftwareTokenRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'VerifySoftwareToken',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserCode'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoVerifyUserAttributeRequest
    extends CognitoConfiguredUserPoolOperationRequest {
  CognitoVerifyUserAttributeRequest({
    required Map<String, dynamic> payload,
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'VerifyUserAttribute',
         payload: payload,
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'AttributeName', 'Code'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

typedef AortemCognitoAdminUserGlobalSignOutRequest =
    CognitoAdminUserGlobalSignOutRequest;
typedef AortemCognitoAssociateSoftwareTokenRequest =
    CognitoAssociateSoftwareTokenRequest;
typedef AortemCognitoChangePasswordRequest = CognitoChangePasswordRequest;
typedef AortemCognitoCompleteWebAuthnRegistrationRequest =
    CognitoCompleteWebAuthnRegistrationRequest;
typedef AortemCognitoConfirmDeviceRequest = CognitoConfirmDeviceRequest;
typedef AortemCognitoConfirmForgotPasswordRequest =
    CognitoConfirmForgotPasswordRequest;
typedef AortemCognitoConfirmSignUpRequest = CognitoConfirmSignUpRequest;
typedef AortemCognitoCreateGroupRequest = CognitoCreateGroupRequest;
typedef AortemCognitoCreateIdentityProviderRequest =
    CognitoCreateIdentityProviderRequest;
typedef AortemCognitoCreateManagedLoginBrandingRequest =
    CognitoCreateManagedLoginBrandingRequest;
typedef AortemCognitoCreateResourceServerRequest =
    CognitoCreateResourceServerRequest;
typedef AortemCognitoCreateUserImportJobRequest =
    CognitoCreateUserImportJobRequest;
typedef AortemCognitoCreateUserPoolRequest = CognitoCreateUserPoolRequest;
typedef AortemCognitoCreateUserPoolClientRequest =
    CognitoCreateUserPoolClientRequest;
typedef AortemCognitoCreateUserPoolDomainRequest =
    CognitoCreateUserPoolDomainRequest;
typedef AortemCognitoDeleteGroupRequest = CognitoDeleteGroupRequest;
typedef AortemCognitoDeleteIdentityProviderRequest =
    CognitoDeleteIdentityProviderRequest;
typedef AortemCognitoDeleteManagedLoginBrandingRequest =
    CognitoDeleteManagedLoginBrandingRequest;
typedef AortemCognitoDeleteResourceServerRequest =
    CognitoDeleteResourceServerRequest;
typedef AortemCognitoDeleteUserRequest = CognitoDeleteUserRequest;
typedef AortemCognitoDeleteUserAttributesRequest =
    CognitoDeleteUserAttributesRequest;
typedef AortemCognitoDeleteUserPoolRequest = CognitoDeleteUserPoolRequest;
typedef AortemCognitoDeleteUserPoolClientRequest =
    CognitoDeleteUserPoolClientRequest;
typedef AortemCognitoDeleteUserPoolDomainRequest =
    CognitoDeleteUserPoolDomainRequest;
typedef AortemCognitoDeleteWebAuthnCredentialRequest =
    CognitoDeleteWebAuthnCredentialRequest;
typedef AortemCognitoDescribeIdentityProviderRequest =
    CognitoDescribeIdentityProviderRequest;
typedef AortemCognitoDescribeManagedLoginBrandingRequest =
    CognitoDescribeManagedLoginBrandingRequest;
typedef AortemCognitoDescribeManagedLoginBrandingByClientRequest =
    CognitoDescribeManagedLoginBrandingByClientRequest;
typedef AortemCognitoDescribeResourceServerRequest =
    CognitoDescribeResourceServerRequest;
typedef AortemCognitoDescribeRiskConfigurationRequest =
    CognitoDescribeRiskConfigurationRequest;
typedef AortemCognitoDescribeUserImportJobRequest =
    CognitoDescribeUserImportJobRequest;
typedef AortemCognitoDescribeUserPoolRequest = CognitoDescribeUserPoolRequest;
typedef AortemCognitoDescribeUserPoolDomainRequest =
    CognitoDescribeUserPoolDomainRequest;
typedef AortemCognitoForgetDeviceRequest = CognitoForgetDeviceRequest;
typedef AortemCognitoForgotPasswordRequest = CognitoForgotPasswordRequest;
typedef AortemCognitoGetCSVHeaderRequest = CognitoGetCSVHeaderRequest;
typedef AortemCognitoGetDeviceRequest = CognitoGetDeviceRequest;
typedef AortemCognitoGetGroupRequest = CognitoGetGroupRequest;
typedef AortemCognitoGetIdentityProviderByIdentifierRequest =
    CognitoGetIdentityProviderByIdentifierRequest;
typedef AortemCognitoSetLogDeliveryConfigurationRequest =
    CognitoSetLogDeliveryConfigurationRequest;
typedef AortemCognitoSetRiskConfigurationRequest =
    CognitoSetRiskConfigurationRequest;
typedef AortemCognitoSetUICustomizationRequest =
    CognitoSetUICustomizationRequest;
typedef AortemCognitoSetUserMFAPreferenceRequest =
    CognitoSetUserMFAPreferenceRequest;
typedef AortemCognitoSetUserPoolMfaConfigRequest =
    CognitoSetUserPoolMfaConfigRequest;
typedef AortemCognitoSetUserSettingsRequest = CognitoSetUserSettingsRequest;
typedef AortemCognitoSignUpRequest = CognitoSignUpRequest;
typedef AortemCognitoStartUserImportJobRequest =
    CognitoStartUserImportJobRequest;
typedef AortemCognitoStopUserImportJobRequest = CognitoStopUserImportJobRequest;
typedef AortemCognitoTagResourceRequest = CognitoTagResourceRequest;
typedef AortemCognitoUntagResourceRequest = CognitoUntagResourceRequest;
typedef AortemCognitoUpdateAuthEventFeedbackRequest =
    CognitoUpdateAuthEventFeedbackRequest;
typedef AortemCognitoUpdateDeviceStatusRequest =
    CognitoUpdateDeviceStatusRequest;
typedef AortemCognitoUpdateGroupRequest = CognitoUpdateGroupRequest;
typedef AortemCognitoUpdateIdentityProviderRequest =
    CognitoUpdateIdentityProviderRequest;
typedef AortemCognitoUpdateManagedLoginBrandingRequest =
    CognitoUpdateManagedLoginBrandingRequest;
typedef AortemCognitoUpdateResourceServerRequest =
    CognitoUpdateResourceServerRequest;
typedef AortemCognitoUpdateUserAttributesRequest =
    CognitoUpdateUserAttributesRequest;
typedef AortemCognitoUpdateUserPoolRequest = CognitoUpdateUserPoolRequest;
typedef AortemCognitoUpdateUserPoolClientRequest =
    CognitoUpdateUserPoolClientRequest;
typedef AortemCognitoUpdateUserPoolDomainRequest =
    CognitoUpdateUserPoolDomainRequest;
typedef AortemCognitoVerifySoftwareTokenRequest =
    CognitoVerifySoftwareTokenRequest;
typedef AortemCognitoVerifyUserAttributeRequest =
    CognitoVerifyUserAttributeRequest;
