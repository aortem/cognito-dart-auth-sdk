import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_user_pool_operations.dart';

typedef CognitoUserPoolOperationConsumerFn =
    void Function(CognitoUserPoolOperationBuilder builder);

class CognitoUserPoolOperationBuilder {
  final Map<String, dynamic> _payload = <String, dynamic>{};

  CognitoUserPoolOperationBuilder userPoolId(String value) =>
      _string('UserPoolId', value);

  CognitoUserPoolOperationBuilder accessToken(String value) =>
      _string('AccessToken', value);

  CognitoUserPoolOperationBuilder clientId(String value) =>
      _string('ClientId', value);

  CognitoUserPoolOperationBuilder username(String value) =>
      _string('Username', value);

  CognitoUserPoolOperationBuilder attributeName(String value) =>
      _string('AttributeName', value);

  CognitoUserPoolOperationBuilder authFlow(String value) =>
      _string('AuthFlow', value);

  CognitoUserPoolOperationBuilder challengeName(String value) =>
      _string('ChallengeName', value);

  CognitoUserPoolOperationBuilder resourceArn(String value) =>
      _string('ResourceArn', value);

  CognitoUserPoolOperationBuilder token(String value) =>
      _string('Token', value);

  CognitoUserPoolOperationBuilder clientSecret(String value) =>
      _string('ClientSecret', value);

  CognitoUserPoolOperationBuilder secretHash(String value) =>
      _string('SecretHash', value);

  CognitoUserPoolOperationBuilder session(String value) =>
      _string('Session', value);

  CognitoUserPoolOperationBuilder nextToken(String value) =>
      _string('NextToken', value);

  CognitoUserPoolOperationBuilder paginationToken(String value) =>
      _string('PaginationToken', value);

  CognitoUserPoolOperationBuilder filter(String value) =>
      _string('Filter', value);

  CognitoUserPoolOperationBuilder limit(int value) => _int('Limit', value);

  CognitoUserPoolOperationBuilder maxResults(int value) =>
      _int('MaxResults', value);

  CognitoUserPoolOperationBuilder authParameters(Map<String, String> value) =>
      _map('AuthParameters', value);

  CognitoUserPoolOperationBuilder clientMetadata(Map<String, String> value) =>
      _map('ClientMetadata', value);

  CognitoUserPoolOperationBuilder challengeResponses(
    Map<String, String> value,
  ) => _map('ChallengeResponses', value);

  CognitoUserPoolOperationBuilder analyticsMetadata(
    Map<String, dynamic> value,
  ) => _map('AnalyticsMetadata', value);

  CognitoUserPoolOperationBuilder userContextData(Map<String, dynamic> value) =>
      _map('UserContextData', value);

  CognitoUserPoolOperationBuilder attributesToGet(List<String> value) {
    if (value.isNotEmpty) {
      _payload['AttributesToGet'] = List<String>.unmodifiable(value);
    }
    return this;
  }

  Map<String, dynamic> buildPayload() => Map<String, dynamic>.unmodifiable(
    Map<String, dynamic>.fromEntries(
      _payload.entries.where((entry) {
        final value = entry.value;
        if (value == null) return false;
        if (value is String) return value.trim().isNotEmpty;
        if (value is Map) return value.isNotEmpty;
        if (value is Iterable) return value.isNotEmpty;
        return true;
      }),
    ),
  );

  CognitoUserPoolOperationBuilder _string(String key, String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _payload[key] = trimmed;
    }
    return this;
  }

  CognitoUserPoolOperationBuilder _int(String key, int value) {
    _payload[key] = value;
    return this;
  }

  CognitoUserPoolOperationBuilder _map(String key, Map<String, dynamic> value) {
    if (value.isNotEmpty) {
      _payload[key] = Map<String, dynamic>.unmodifiable(value);
    }
    return this;
  }
}

abstract class CognitoUserPoolOperationConsumer {
  final String operation;
  final String region;
  final CognitoHttpClient httpClient;
  final List<String> requiredStrings;
  final List<String> requiredInts;
  final List<String> requiredMaps;
  final List<String> optionalLimits;
  final int maxRetries;
  final Duration requestTimeout;

  CognitoUserPoolOperationConsumer({
    required this.operation,
    required this.region,
    required this.httpClient,
    this.requiredStrings = const <String>[],
    this.requiredInts = const <String>[],
    this.requiredMaps = const <String>[],
    this.optionalLimits = const <String>[],
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  Future<CognitoJsonOperationResult> run(
    CognitoUserPoolOperationConsumerFn consumer,
  ) {
    final builder = CognitoUserPoolOperationBuilder();
    consumer(builder);
    final request = CognitoGenericUserPoolOperationRequest(
      operation: operation,
      region: region,
      httpClient: httpClient,
      payload: builder.buildPayload(),
      requiredStrings: requiredStrings,
      requiredInts: requiredInts,
      requiredMaps: requiredMaps,
      optionalLimits: optionalLimits,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return request.execute();
  }
}

class CognitoGetLogDeliveryConfigurationConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoGetLogDeliveryConfigurationConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetLogDeliveryConfiguration',
         requiredStrings: const ['UserPoolId'],
       );
}

class CognitoGetSigningCertificateConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoGetSigningCertificateConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetSigningCertificate',
         requiredStrings: const ['UserPoolId'],
       );
}

class CognitoGetUICustomizationConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoGetUICustomizationConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUICustomization',
         requiredStrings: const ['UserPoolId'],
       );
}

class CognitoGetUserConsumer extends CognitoUserPoolOperationConsumer {
  CognitoGetUserConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(operation: 'GetUser', requiredStrings: const ['AccessToken']);
}

class CognitoGetUserAttributeVerificationCodeConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoGetUserAttributeVerificationCodeConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUserAttributeVerificationCode',
         requiredStrings: const ['AccessToken', 'AttributeName'],
       );
}

class CognitoGetUserPoolMfaConfigConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoGetUserPoolMfaConfigConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUserPoolMfaConfig',
         requiredStrings: const ['UserPoolId'],
       );
}

class CognitoGlobalSignOutConsumer extends CognitoUserPoolOperationConsumer {
  CognitoGlobalSignOutConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GlobalSignOut',
         requiredStrings: const ['AccessToken'],
       );
}

class CognitoInitiateAuthConsumer extends CognitoUserPoolOperationConsumer {
  CognitoInitiateAuthConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'InitiateAuth',
         requiredStrings: const ['AuthFlow', 'ClientId'],
       );
}

class CognitoListDevicesConsumer extends CognitoUserPoolOperationConsumer {
  CognitoListDevicesConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListDevices',
         requiredStrings: const ['AccessToken'],
         optionalLimits: const ['Limit'],
       );
}

class CognitoListGroupsConsumer extends CognitoUserPoolOperationConsumer {
  CognitoListGroupsConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListGroups',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['Limit'],
       );
}

class CognitoListGroupsPaginatorConsumer extends CognitoListGroupsConsumer {
  CognitoListGroupsPaginatorConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListIdentityProvidersConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoListIdentityProvidersConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListIdentityProviders',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
       );
}

class CognitoListIdentityProvidersPaginatorConsumer
    extends CognitoListIdentityProvidersConsumer {
  CognitoListIdentityProvidersPaginatorConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListResourceServersConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoListResourceServersConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListResourceServers',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
       );
}

class CognitoListResourceServersPaginatorConsumer
    extends CognitoListResourceServersConsumer {
  CognitoListResourceServersPaginatorConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListTagsForResourceConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoListTagsForResourceConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListTagsForResource',
         requiredStrings: const ['ResourceArn'],
       );
}

class CognitoListUserImportJobsConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoListUserImportJobsConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUserImportJobs',
         requiredStrings: const ['UserPoolId'],
         requiredInts: const ['MaxResults'],
       );
}

class CognitoListUserPoolClientsConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoListUserPoolClientsConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUserPoolClients',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
       );
}

class CognitoListUserPoolsConsumer extends CognitoUserPoolOperationConsumer {
  CognitoListUserPoolsConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(operation: 'ListUserPools', requiredInts: const ['MaxResults']);
}

class CognitoListUsersConsumer extends CognitoUserPoolOperationConsumer {
  CognitoListUsersConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUsers',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['Limit'],
       );
}

class CognitoListUsersPaginatorConsumer extends CognitoListUsersConsumer {
  CognitoListUsersPaginatorConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoResendConfirmationCodeConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoResendConfirmationCodeConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ResendConfirmationCode',
         requiredStrings: const ['ClientId', 'Username'],
       );
}

class CognitoRespondToAuthChallengeConsumer
    extends CognitoUserPoolOperationConsumer {
  CognitoRespondToAuthChallengeConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'RespondToAuthChallenge',
         requiredStrings: const ['ChallengeName', 'ClientId'],
       );
}

class CognitoRevokeTokenConsumer extends CognitoUserPoolOperationConsumer {
  CognitoRevokeTokenConsumer({
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'RevokeToken',
         requiredStrings: const ['Token', 'ClientId'],
       );
}

typedef AortemCognitoGetLogDeliveryConfigurationConsumer =
    CognitoGetLogDeliveryConfigurationConsumer;
typedef AortemCognitoGetSigningCertificateConsumer =
    CognitoGetSigningCertificateConsumer;
typedef AortemCognitoGetUICustomizationConsumer =
    CognitoGetUICustomizationConsumer;
typedef AortemCognitoGetUserConsumer = CognitoGetUserConsumer;
typedef AortemCognitoGetUserAttributeVerificationCodeConsumer =
    CognitoGetUserAttributeVerificationCodeConsumer;
typedef AortemCognitoGetUserPoolMfaConfigConsumer =
    CognitoGetUserPoolMfaConfigConsumer;
typedef AortemCognitoGlobalSignOutConsumer = CognitoGlobalSignOutConsumer;
typedef AortemCognitoInitiateAuthConsumer = CognitoInitiateAuthConsumer;
typedef AortemCognitoListDevicesConsumer = CognitoListDevicesConsumer;
typedef AortemCognitoListGroupsConsumer = CognitoListGroupsConsumer;
typedef AortemCognitoListGroupsPaginatorConsumer =
    CognitoListGroupsPaginatorConsumer;
typedef AortemCognitoListIdentityProvidersConsumer =
    CognitoListIdentityProvidersConsumer;
typedef AortemCognitoListIdentityProvidersPaginatorConsumer =
    CognitoListIdentityProvidersPaginatorConsumer;
typedef AortemCognitoListResourceServersConsumer =
    CognitoListResourceServersConsumer;
typedef AortemCognitoListResourceServersPaginatorConsumer =
    CognitoListResourceServersPaginatorConsumer;
typedef AortemCognitoListTagsForResourceConsumer =
    CognitoListTagsForResourceConsumer;
typedef AortemCognitoListUserImportJobsConsumer =
    CognitoListUserImportJobsConsumer;
typedef AortemCognitoListUserPoolClientsConsumer =
    CognitoListUserPoolClientsConsumer;
typedef AortemCognitoListUserPoolsConsumer = CognitoListUserPoolsConsumer;
typedef AortemCognitoListUsersConsumer = CognitoListUsersConsumer;
typedef AortemCognitoListUsersPaginatorConsumer =
    CognitoListUsersPaginatorConsumer;
typedef AortemCognitoResendConfirmationCodeConsumer =
    CognitoResendConfirmationCodeConsumer;
typedef AortemCognitoRespondToAuthChallengeConsumer =
    CognitoRespondToAuthChallengeConsumer;
typedef AortemCognitoRevokeTokenConsumer = CognitoRevokeTokenConsumer;
