/// AdminDisableProviderForUser — Prevents a user from signing in with a specific identity provider.
///
/// This request allows administrators to disable a specific authentication provider
/// for a user while keeping other providers active.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminDisableProviderForUser.html
library cognito_admin_disable_provider_for_user_request;

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// Result container for successful AdminDisableProviderForUser operations.
///
/// The AWS API returns an empty response on success, so this serves
/// as a type-safe marker for completion.
class AortemCognitoAdminDisableProviderForUserResult {
  /// Creates a new successful result instance
  const AortemCognitoAdminDisableProviderForUserResult();
}

/// Identifies a user with a specific identity provider.
///
/// This contains the necessary information to locate a user's
/// identity provider linkage in Cognito.
class AortemCognitoProviderUserIdentifier {
  /// The name of the identity provider as configured in Cognito
  /// (e.g., 'Google', 'Facebook', 'Cognito', 'MySamlIdP')
  final String providerName;

  /// The attribute name used to identify the user with the provider
  /// (typically 'Cognito_Subject' for social/SAML providers)
  final String providerAttributeName;

  /// The unique identifier value from the identity provider
  final String providerAttributeValue;

  /// Creates a new provider user identifier
  const AortemCognitoProviderUserIdentifier({
    required this.providerName,
    required this.providerAttributeName,
    required this.providerAttributeValue,
  });

  /// Validates the identifier fields
  ///
  /// @throws AortemCognitoValidationException if any fields are invalid
  void validate() {
    if (providerName.trim().isEmpty) {
      throw AortemCognitoValidationException('providerName is required.');
    }
    if (providerAttributeName.trim().isEmpty) {
      throw AortemCognitoValidationException(
        'providerAttributeName is required.',
      );
    }
    if (providerAttributeValue.trim().isEmpty) {
      throw AortemCognitoValidationException(
        'providerAttributeValue is required.',
      );
    }
  }

  /// Converts the identifier to JSON format for API requests
  Map<String, dynamic> toJson() => <String, dynamic>{
    'ProviderName': providerName,
    'ProviderAttributeName': providerAttributeName,
    'ProviderAttributeValue': providerAttributeValue,
  };
}

/// Request class for AdminDisableProviderForUser API operation.
///
/// This prevents a user from signing in with a specific identity provider
/// while allowing other authentication methods to remain active.
class AortemCognitoAdminDisableProviderForUserRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The provider user identifier to disable
  final AortemCognitoProviderUserIdentifier user;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for the request
  final Duration requestTimeout;

  /// Creates a new AdminDisableProviderForUser request
  ///
  /// @param userPoolId Required user pool ID
  /// @param user Required provider user identifier
  /// @param region AWS region for the user pool
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  AortemCognitoAdminDisableProviderForUserRequest({
    required this.userPoolId,
    required this.user,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters
  ///
  /// @throws AortemCognitoValidationException if any parameters are invalid
  void _validate() {
    // Pattern: [\w-]+_[0-9a-zA-Z]+
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    user.validate();
  }

  /// Builds the request payload for the AWS API
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'User': user.toJson(),
  };

  /// Executes the AdminDisableProviderForUser request
  ///
  /// @return Future resolving to AdminDisableProviderForUserResult on success
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminDisableProviderForUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target:
              'AWSCognitoIdentityProviderService.AdminDisableProviderForUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const AortemCognitoAdminDisableProviderForUserResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminDisableProviderForUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminDisableProviderForUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminDisableProviderForUser unexpected status.',
          statusCode: res.statusCode,
        );
      } catch (e) {
        lastError = e;
        final transient = _isTransient(e);
        if (!transient || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw AortemCognitoServiceException(
      'AdminDisableProviderForUser failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
