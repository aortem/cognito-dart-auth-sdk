// ignore_for_file: use_super_parameters

import 'package:cognito_dart_auth_sdk/consumers/cognito_confirm_signup_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_user_pool_operation_consumers.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

abstract class CognitoConfiguredUserPoolOperationConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoConfiguredUserPoolOperationConsumer({
    required super.operation,
    required super.region,
    required super.httpClient,
    super.requiredStrings,
    super.requiredInts,
    super.requiredMaps,
    super.requiredLists,
    super.optionalLimits,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoAdminUserGlobalSignOutConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoAdminUserGlobalSignOutConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'AdminUserGlobalSignOut',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Username'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoAssociateSoftwareTokenConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoAssociateSoftwareTokenConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'AssociateSoftwareToken',
         region: region,
         httpClient: httpClient,
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoChangePasswordConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoChangePasswordConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ChangePassword',
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

class CognitoCompleteWebAuthnRegistrationConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCompleteWebAuthnRegistrationConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CompleteWebAuthnRegistration',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         requiredMaps: const ['Credential'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoConfirmDeviceConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoConfirmDeviceConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ConfirmDevice',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoConfirmForgotPasswordConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoConfirmForgotPasswordConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ConfirmForgotPassword',
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

class CognitoCreateGroupConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateGroupConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateGroup',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateIdentityProviderConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateIdentityProviderConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateIdentityProvider',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName', 'ProviderType'],
         requiredMaps: const ['ProviderDetails'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateManagedLoginBrandingConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateManagedLoginBrandingConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateManagedLoginBranding',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateResourceServerConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateResourceServerConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateResourceServer',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier', 'Name'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserImportJobConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateUserImportJobConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserImportJob',
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

class CognitoCreateUserPoolConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateUserPoolConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPool',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['PoolName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserPoolClientConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateUserPoolClientConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPoolClient',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoCreateUserPoolDomainConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoCreateUserPoolDomainConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'CreateUserPoolDomain',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain', 'UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteGroupConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteGroupConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteGroup',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteIdentityProviderConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteIdentityProviderConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteIdentityProvider',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteManagedLoginBrandingConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteManagedLoginBrandingConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteManagedLoginBranding',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ManagedLoginBrandingId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteResourceServerConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteResourceServerConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteResourceServer',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteUserConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUser',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserAttributesConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteUserAttributesConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserAttributes',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         requiredLists: const ['UserAttributeNames'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteUserPoolConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPool',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolClientConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteUserPoolClientConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPoolClient',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteUserPoolDomainConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteUserPoolDomainConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteUserPoolDomain',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain', 'UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDeleteWebAuthnCredentialConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDeleteWebAuthnCredentialConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DeleteWebAuthnCredential',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken', 'CredentialId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeIdentityProviderConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeIdentityProviderConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeIdentityProvider',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ProviderName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeManagedLoginBrandingConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeManagedLoginBrandingConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeManagedLoginBranding',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ManagedLoginBrandingId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeManagedLoginBrandingByClientConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeManagedLoginBrandingByClientConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeManagedLoginBrandingByClient',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'ClientId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeResourceServerConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeResourceServerConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeResourceServer',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'Identifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeRiskConfigurationConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeRiskConfigurationConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeRiskConfiguration',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserImportJobConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeUserImportJobConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserImportJob',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'JobId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserPoolConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeUserPoolConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserPool',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoDescribeUserPoolDomainConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoDescribeUserPoolDomainConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'DescribeUserPoolDomain',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['Domain'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoForgetDeviceConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoForgetDeviceConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ForgetDevice',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoForgotPasswordConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoForgotPasswordConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'ForgotPassword',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['ClientId', 'Username'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetCSVHeaderConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoGetCSVHeaderConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetCSVHeader',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetDeviceConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoGetDeviceConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetDevice',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['DeviceKey'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetGroupConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoGetGroupConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetGroup',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'GroupName'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoGetIdentityProviderByIdentifierConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoGetIdentityProviderByIdentifierConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'GetIdentityProviderByIdentifier',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId', 'IdpIdentifier'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetLogDeliveryConfigurationConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoSetLogDeliveryConfigurationConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetLogDeliveryConfiguration',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         requiredLists: const ['LogConfigurations'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetRiskConfigurationConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoSetRiskConfigurationConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetRiskConfiguration',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUICustomizationConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoSetUICustomizationConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUICustomization',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUserMFAPreferenceConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoSetUserMFAPreferenceConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUserMFAPreference',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['AccessToken'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

class CognitoSetUserPoolMfaConfigConsumer
    extends CognitoConfiguredUserPoolOperationConsumer {
  CognitoSetUserPoolMfaConfigConsumer({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) : super(
         operation: 'SetUserPoolMfaConfig',
         region: region,
         httpClient: httpClient,
         requiredStrings: const ['UserPoolId'],
         maxRetries: maxRetries,
         requestTimeout: requestTimeout,
       );
}

typedef AortemCognitoAdminUserGlobalSignOutConsumer =
    CognitoAdminUserGlobalSignOutConsumer;
typedef AortemCognitoAssociateSoftwareTokenConsumer =
    CognitoAssociateSoftwareTokenConsumer;
typedef AortemCognitoChangePasswordConsumer = CognitoChangePasswordConsumer;
typedef AortemCognitoCompleteWebAuthnRegistrationConsumer =
    CognitoCompleteWebAuthnRegistrationConsumer;
typedef AortemCognitoConfirmDeviceConsumer = CognitoConfirmDeviceConsumer;
typedef AortemCognitoConfirmForgotPasswordConsumer =
    CognitoConfirmForgotPasswordConsumer;
typedef AortemCognitoConfirmSignUpConsumer = CognitoConfirmSignUpConsumer;
typedef AortemCognitoCreateGroupConsumer = CognitoCreateGroupConsumer;
typedef AortemCognitoCreateIdentityProviderConsumer =
    CognitoCreateIdentityProviderConsumer;
typedef AortemCognitoCreateManagedLoginBrandingConsumer =
    CognitoCreateManagedLoginBrandingConsumer;
typedef AortemCognitoCreateResourceServerConsumer =
    CognitoCreateResourceServerConsumer;
typedef AortemCognitoCreateUserImportJobConsumer =
    CognitoCreateUserImportJobConsumer;
typedef AortemCognitoCreateUserPoolConsumer = CognitoCreateUserPoolConsumer;
typedef AortemCognitoCreateUserPoolClientConsumer =
    CognitoCreateUserPoolClientConsumer;
typedef AortemCognitoCreateUserPoolDomainConsumer =
    CognitoCreateUserPoolDomainConsumer;
typedef AortemCognitoDeleteGroupConsumer = CognitoDeleteGroupConsumer;
typedef AortemCognitoDeleteIdentityProviderConsumer =
    CognitoDeleteIdentityProviderConsumer;
typedef AortemCognitoDeleteManagedLoginBrandingConsumer =
    CognitoDeleteManagedLoginBrandingConsumer;
typedef AortemCognitoDeleteResourceServerConsumer =
    CognitoDeleteResourceServerConsumer;
typedef AortemCognitoDeleteUserConsumer = CognitoDeleteUserConsumer;
typedef AortemCognitoDeleteUserAttributesConsumer =
    CognitoDeleteUserAttributesConsumer;
typedef AortemCognitoDeleteUserPoolConsumer = CognitoDeleteUserPoolConsumer;
typedef AortemCognitoDeleteUserPoolClientConsumer =
    CognitoDeleteUserPoolClientConsumer;
typedef AortemCognitoDeleteUserPoolDomainConsumer =
    CognitoDeleteUserPoolDomainConsumer;
typedef AortemCognitoDeleteWebAuthnCredentialConsumer =
    CognitoDeleteWebAuthnCredentialConsumer;
typedef AortemCognitoDescribeIdentityProviderConsumer =
    CognitoDescribeIdentityProviderConsumer;
typedef AortemCognitoDescribeManagedLoginBrandingConsumer =
    CognitoDescribeManagedLoginBrandingConsumer;
typedef AortemCognitoDescribeManagedLoginBrandingByClientConsumer =
    CognitoDescribeManagedLoginBrandingByClientConsumer;
typedef AortemCognitoDescribeResourceServerConsumer =
    CognitoDescribeResourceServerConsumer;
typedef AortemCognitoDescribeRiskConfigurationConsumer =
    CognitoDescribeRiskConfigurationConsumer;
typedef AortemCognitoDescribeUserImportJobConsumer =
    CognitoDescribeUserImportJobConsumer;
typedef AortemCognitoDescribeUserPoolConsumer = CognitoDescribeUserPoolConsumer;
typedef AortemCognitoDescribeUserPoolDomainConsumer =
    CognitoDescribeUserPoolDomainConsumer;
typedef AortemCognitoForgetDeviceConsumer = CognitoForgetDeviceConsumer;
typedef AortemCognitoForgotPasswordConsumer = CognitoForgotPasswordConsumer;
typedef AortemCognitoGetCSVHeaderConsumer = CognitoGetCSVHeaderConsumer;
typedef AortemCognitoGetDeviceConsumer = CognitoGetDeviceConsumer;
typedef AortemCognitoGetGroupConsumer = CognitoGetGroupConsumer;
typedef AortemCognitoGetIdentityProviderByIdentifierConsumer =
    CognitoGetIdentityProviderByIdentifierConsumer;
typedef AortemCognitoSetLogDeliveryConfigurationConsumer =
    CognitoSetLogDeliveryConfigurationConsumer;
typedef AortemCognitoSetRiskConfigurationConsumer =
    CognitoSetRiskConfigurationConsumer;
typedef AortemCognitoSetUICustomizationConsumer =
    CognitoSetUICustomizationConsumer;
typedef AortemCognitoSetUserMFAPreferenceConsumer =
    CognitoSetUserMFAPreferenceConsumer;
typedef AortemCognitoSetUserPoolMfaConfigConsumer =
    CognitoSetUserPoolMfaConfigConsumer;
