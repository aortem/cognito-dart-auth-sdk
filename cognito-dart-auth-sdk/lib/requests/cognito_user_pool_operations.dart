import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Result wrapper for Cognito JSON operations.
class CognitoJsonOperationResult {
  final bool success;
  final Map<String, dynamic> body;

  const CognitoJsonOperationResult({required this.success, required this.body});
}

/// Shared executor for Cognito Identity Provider JSON API operations.
abstract class CognitoJsonOperationRequest {
  final String operation;
  final String region;
  final CognitoHttpClient httpClient;
  final Map<String, dynamic> payload;
  final int maxRetries;
  final Duration requestTimeout;

  CognitoJsonOperationRequest({
    required this.operation,
    required this.region,
    required this.httpClient,
    required this.payload,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validatePayload(payload);
  }

  String get target => 'AWSCognitoIdentityProviderService.$operation';

  Future<CognitoJsonOperationResult> execute() async {
    var attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final response = await httpClient.send(
          service: 'cognito-idp',
          target: target,
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (response.statusCode == 200) {
          return CognitoJsonOperationResult(
            success: true,
            body: response.jsonBody ?? const <String, dynamic>{},
          );
        }
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw CognitoServiceException(
            '$operation failed. Body: ${response.bodyString}',
            statusCode: response.statusCode,
          );
        }
        if (response.statusCode >= 500) {
          throw CognitoServiceException(
            '$operation temporary failure.',
            statusCode: response.statusCode,
          );
        }
        throw CognitoServiceException(
          '$operation unexpected status.',
          statusCode: response.statusCode,
        );
      } catch (e) {
        lastError = e;
        if (!_isTransient(e) || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw CognitoServiceException(
      '$operation failed after retries. Last error: $lastError',
    );
  }

  void _validatePayload(Map<String, dynamic> payload);

  bool _isTransient(Object e) {
    final value = e.toString();
    return value.contains('temporary') ||
        value.contains('SocketException') ||
        value.contains('TimeoutException') ||
        value.contains('503') ||
        value.contains('500');
  }
}

void _requireString(Map<String, dynamic> payload, String key) {
  final value = payload[key];
  if (value is! String || value.trim().isEmpty) {
    throw CognitoValidationException('$key is required.');
  }
}

void _requireInt(Map<String, dynamic> payload, String key) {
  final value = payload[key];
  if (value is! int || value <= 0) {
    throw CognitoValidationException('$key is required and must be positive.');
  }
}

void _requireMap(Map<String, dynamic> payload, String key) {
  final value = payload[key];
  if (value is! Map || value.isEmpty) {
    throw CognitoValidationException('$key is required.');
  }
}

void _validateOptionalLimit(Map<String, dynamic> payload, String key) {
  final value = payload[key];
  if (value != null && (value is! int || value <= 0)) {
    throw CognitoValidationException('$key must be positive when provided.');
  }
}

Map<String, dynamic> _clean(Map<String, dynamic> payload) {
  return Map<String, dynamic>.fromEntries(
    payload.entries.where((entry) {
      final value = entry.value;
      if (value == null) return false;
      if (value is String) return value.trim().isNotEmpty;
      if (value is Map) return value.isNotEmpty;
      if (value is Iterable) return value.isNotEmpty;
      return true;
    }),
  );
}

abstract class _SimpleCognitoRequest extends CognitoJsonOperationRequest {
  final List<String> requiredStrings;
  final List<String> requiredMaps;
  final List<String> requiredInts;
  final List<String> optionalLimits;

  _SimpleCognitoRequest({
    required super.operation,
    required super.region,
    required super.httpClient,
    required Map<String, dynamic> payload,
    this.requiredStrings = const <String>[],
    this.requiredMaps = const <String>[],
    this.requiredInts = const <String>[],
    this.optionalLimits = const <String>[],
    super.maxRetries,
    super.requestTimeout,
  }) : super(payload: _clean(payload));

  @override
  void _validatePayload(Map<String, dynamic> payload) {
    for (final key in requiredStrings) {
      _requireString(payload, key);
    }
    for (final key in requiredMaps) {
      _requireMap(payload, key);
    }
    for (final key in requiredInts) {
      _requireInt(payload, key);
    }
    for (final key in optionalLimits) {
      _validateOptionalLimit(payload, key);
    }
  }
}

class CognitoGenericUserPoolOperationRequest extends _SimpleCognitoRequest {
  CognitoGenericUserPoolOperationRequest({
    required super.operation,
    required super.region,
    required super.httpClient,
    required super.payload,
    super.requiredStrings,
    super.requiredMaps,
    super.requiredInts,
    super.optionalLimits,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoGetLogDeliveryConfigurationRequest extends _SimpleCognitoRequest {
  CognitoGetLogDeliveryConfigurationRequest({
    required String userPoolId,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetLogDeliveryConfiguration',
         requiredStrings: const ['UserPoolId'],
         payload: {'UserPoolId': userPoolId},
       );
}

class CognitoGetSigningCertificateRequest extends _SimpleCognitoRequest {
  CognitoGetSigningCertificateRequest({
    required String userPoolId,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetSigningCertificate',
         requiredStrings: const ['UserPoolId'],
         payload: {'UserPoolId': userPoolId},
       );
}

class CognitoGetUICustomizationRequest extends _SimpleCognitoRequest {
  CognitoGetUICustomizationRequest({
    required String userPoolId,
    String? clientId,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUICustomization',
         requiredStrings: const ['UserPoolId'],
         payload: {'UserPoolId': userPoolId, 'ClientId': clientId},
       );
}

class CognitoGetUserRequest extends _SimpleCognitoRequest {
  CognitoGetUserRequest({
    required String accessToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUser',
         requiredStrings: const ['AccessToken'],
         payload: {'AccessToken': accessToken},
       );
}

class CognitoGetUserAttributeVerificationCodeRequest
    extends _SimpleCognitoRequest {
  CognitoGetUserAttributeVerificationCodeRequest({
    required String accessToken,
    required String attributeName,
    Map<String, String>? clientMetadata,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUserAttributeVerificationCode',
         requiredStrings: const ['AccessToken', 'AttributeName'],
         payload: {
           'AccessToken': accessToken,
           'AttributeName': attributeName,
           'ClientMetadata': clientMetadata,
         },
       );
}

class CognitoGetUserPoolMfaConfigRequest extends _SimpleCognitoRequest {
  CognitoGetUserPoolMfaConfigRequest({
    required String userPoolId,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GetUserPoolMfaConfig',
         requiredStrings: const ['UserPoolId'],
         payload: {'UserPoolId': userPoolId},
       );
}

class CognitoGlobalSignOutRequest extends _SimpleCognitoRequest {
  CognitoGlobalSignOutRequest({
    required String accessToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'GlobalSignOut',
         requiredStrings: const ['AccessToken'],
         payload: {'AccessToken': accessToken},
       );
}

class CognitoInitiateAuthRequest extends _SimpleCognitoRequest {
  CognitoInitiateAuthRequest({
    required String authFlow,
    required String clientId,
    Map<String, String>? authParameters,
    Map<String, String>? clientMetadata,
    Map<String, dynamic>? analyticsMetadata,
    Map<String, dynamic>? userContextData,
    String? session,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'InitiateAuth',
         requiredStrings: const ['AuthFlow', 'ClientId'],
         payload: {
           'AuthFlow': authFlow,
           'ClientId': clientId,
           'AuthParameters': authParameters,
           'ClientMetadata': clientMetadata,
           'AnalyticsMetadata': analyticsMetadata,
           'UserContextData': userContextData,
           'Session': session,
         },
       );
}

class CognitoListDevicesRequest extends _SimpleCognitoRequest {
  CognitoListDevicesRequest({
    required String accessToken,
    int? limit,
    String? paginationToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListDevices',
         requiredStrings: const ['AccessToken'],
         optionalLimits: const ['Limit'],
         payload: {
           'AccessToken': accessToken,
           'Limit': limit,
           'PaginationToken': paginationToken,
         },
       );
}

class CognitoListGroupsRequest extends _SimpleCognitoRequest {
  CognitoListGroupsRequest({
    required String userPoolId,
    int? limit,
    String? nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListGroups',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['Limit'],
         payload: {
           'UserPoolId': userPoolId,
           'Limit': limit,
           'NextToken': nextToken,
         },
       );
}

class CognitoListGroupsPaginatorRequest extends CognitoListGroupsRequest {
  CognitoListGroupsPaginatorRequest({
    required super.userPoolId,
    super.limit,
    super.nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListIdentityProvidersRequest extends _SimpleCognitoRequest {
  CognitoListIdentityProvidersRequest({
    required String userPoolId,
    int? maxResults,
    String? nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListIdentityProviders',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
         payload: {
           'UserPoolId': userPoolId,
           'MaxResults': maxResults,
           'NextToken': nextToken,
         },
       );
}

class CognitoListIdentityProvidersPaginatorRequest
    extends CognitoListIdentityProvidersRequest {
  CognitoListIdentityProvidersPaginatorRequest({
    required super.userPoolId,
    super.maxResults,
    super.nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListResourceServersRequest extends _SimpleCognitoRequest {
  CognitoListResourceServersRequest({
    required String userPoolId,
    int? maxResults,
    String? nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListResourceServers',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
         payload: {
           'UserPoolId': userPoolId,
           'MaxResults': maxResults,
           'NextToken': nextToken,
         },
       );
}

class CognitoListResourceServersPaginatorRequest
    extends CognitoListResourceServersRequest {
  CognitoListResourceServersPaginatorRequest({
    required super.userPoolId,
    super.maxResults,
    super.nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoListTagsForResourceRequest extends _SimpleCognitoRequest {
  CognitoListTagsForResourceRequest({
    required String resourceArn,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListTagsForResource',
         requiredStrings: const ['ResourceArn'],
         payload: {'ResourceArn': resourceArn},
       );
}

class CognitoListUserImportJobsRequest extends _SimpleCognitoRequest {
  CognitoListUserImportJobsRequest({
    required String userPoolId,
    required int maxResults,
    String? paginationToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUserImportJobs',
         requiredStrings: const ['UserPoolId'],
         requiredInts: const ['MaxResults'],
         payload: {
           'UserPoolId': userPoolId,
           'MaxResults': maxResults,
           'PaginationToken': paginationToken,
         },
       );
}

class CognitoListUserPoolClientsRequest extends _SimpleCognitoRequest {
  CognitoListUserPoolClientsRequest({
    required String userPoolId,
    int? maxResults,
    String? nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUserPoolClients',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['MaxResults'],
         payload: {
           'UserPoolId': userPoolId,
           'MaxResults': maxResults,
           'NextToken': nextToken,
         },
       );
}

class CognitoListUserPoolsRequest extends _SimpleCognitoRequest {
  CognitoListUserPoolsRequest({
    required int maxResults,
    String? nextToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUserPools',
         requiredInts: const ['MaxResults'],
         payload: {'MaxResults': maxResults, 'NextToken': nextToken},
       );
}

class CognitoListUsersRequest extends _SimpleCognitoRequest {
  CognitoListUsersRequest({
    required String userPoolId,
    List<String>? attributesToGet,
    String? filter,
    int? limit,
    String? paginationToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ListUsers',
         requiredStrings: const ['UserPoolId'],
         optionalLimits: const ['Limit'],
         payload: {
           'UserPoolId': userPoolId,
           'AttributesToGet': attributesToGet,
           'Filter': filter,
           'Limit': limit,
           'PaginationToken': paginationToken,
         },
       );
}

class CognitoListUsersPaginatorRequest extends CognitoListUsersRequest {
  CognitoListUsersPaginatorRequest({
    required super.userPoolId,
    super.attributesToGet,
    super.filter,
    super.limit,
    super.paginationToken,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  });
}

class CognitoResendConfirmationCodeRequest extends _SimpleCognitoRequest {
  CognitoResendConfirmationCodeRequest({
    required String clientId,
    required String username,
    String? secretHash,
    Map<String, String>? clientMetadata,
    Map<String, dynamic>? analyticsMetadata,
    Map<String, dynamic>? userContextData,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'ResendConfirmationCode',
         requiredStrings: const ['ClientId', 'Username'],
         payload: {
           'ClientId': clientId,
           'Username': username,
           'SecretHash': secretHash,
           'ClientMetadata': clientMetadata,
           'AnalyticsMetadata': analyticsMetadata,
           'UserContextData': userContextData,
         },
       );
}

class CognitoRespondToAuthChallengeRequest extends _SimpleCognitoRequest {
  CognitoRespondToAuthChallengeRequest({
    required String challengeName,
    required String clientId,
    Map<String, String>? challengeResponses,
    String? session,
    Map<String, dynamic>? analyticsMetadata,
    Map<String, dynamic>? userContextData,
    Map<String, String>? clientMetadata,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'RespondToAuthChallenge',
         requiredStrings: const ['ChallengeName', 'ClientId'],
         payload: {
           'ChallengeName': challengeName,
           'ClientId': clientId,
           'ChallengeResponses': challengeResponses,
           'Session': session,
           'AnalyticsMetadata': analyticsMetadata,
           'UserContextData': userContextData,
           'ClientMetadata': clientMetadata,
         },
       );
}

class CognitoRevokeTokenRequest extends _SimpleCognitoRequest {
  CognitoRevokeTokenRequest({
    required String token,
    required String clientId,
    String? clientSecret,
    required super.region,
    required super.httpClient,
    super.maxRetries,
    super.requestTimeout,
  }) : super(
         operation: 'RevokeToken',
         requiredStrings: const ['Token', 'ClientId'],
         payload: {
           'Token': token,
           'ClientId': clientId,
           'ClientSecret': clientSecret,
         },
       );
}

typedef AortemCognitoGetLogDeliveryConfigurationRequest =
    CognitoGetLogDeliveryConfigurationRequest;
typedef AortemCognitoGetSigningCertificateRequest =
    CognitoGetSigningCertificateRequest;
typedef AortemCognitoGetUICustomizationRequest =
    CognitoGetUICustomizationRequest;
typedef AortemCognitoGetUserRequest = CognitoGetUserRequest;
typedef AortemCognitoGetUserAttributeVerificationCodeRequest =
    CognitoGetUserAttributeVerificationCodeRequest;
typedef AortemCognitoGetUserPoolMfaConfigRequest =
    CognitoGetUserPoolMfaConfigRequest;
typedef AortemCognitoGlobalSignOutRequest = CognitoGlobalSignOutRequest;
typedef AortemCognitoInitiateAuthRequest = CognitoInitiateAuthRequest;
typedef AortemCognitoListDevicesRequest = CognitoListDevicesRequest;
typedef AortemCognitoListGroupsRequest = CognitoListGroupsRequest;
typedef AortemCognitoListGroupsPaginatorRequest =
    CognitoListGroupsPaginatorRequest;
typedef AortemCognitoListIdentityProvidersRequest =
    CognitoListIdentityProvidersRequest;
typedef AortemCognitoListIdentityProvidersPaginatorRequest =
    CognitoListIdentityProvidersPaginatorRequest;
typedef AortemCognitoListResourceServersRequest =
    CognitoListResourceServersRequest;
typedef AortemCognitoListResourceServersPaginatorRequest =
    CognitoListResourceServersPaginatorRequest;
typedef AortemCognitoListTagsForResourceRequest =
    CognitoListTagsForResourceRequest;
typedef AortemCognitoListUserImportJobsRequest =
    CognitoListUserImportJobsRequest;
typedef AortemCognitoListUserPoolClientsRequest =
    CognitoListUserPoolClientsRequest;
typedef AortemCognitoListUserPoolsRequest = CognitoListUserPoolsRequest;
typedef AortemCognitoListUsersRequest = CognitoListUsersRequest;
typedef AortemCognitoListUsersPaginatorRequest =
    CognitoListUsersPaginatorRequest;
typedef AortemCognitoResendConfirmationCodeRequest =
    CognitoResendConfirmationCodeRequest;
typedef AortemCognitoRespondToAuthChallengeRequest =
    CognitoRespondToAuthChallengeRequest;
typedef AortemCognitoRevokeTokenRequest = CognitoRevokeTokenRequest;
