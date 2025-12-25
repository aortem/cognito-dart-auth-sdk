/// AdminEnableUser — Reactivates a disabled user in a Cognito user pool.
///
/// This request allows administrators to re-enable a previously disabled user account,
/// restoring their ability to sign in while maintaining all their profile data.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminEnableUser.html
library _cognito_admin_enable_user_request;

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Result container for successful AdminEnableUser operations.
///
/// The AWS API returns an empty response on success, so this serves
/// as a type-safe marker for completion.
class CognitoAdminEnableUserResult {
  /// Creates a new successful result instance
  const CognitoAdminEnableUserResult();
}

/// Request class for AdminEnableUser API operation.
///
/// This restores a disabled user's ability to sign in while maintaining
/// their profile and attributes in the user pool.
class CognitoAdminEnableUserRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The username to re-enable
  final String username;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for the request
  final Duration requestTimeout;

  /// Creates a new AdminEnableUser request
  ///
  /// @param userPoolId Required user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @param username Required username to enable (1-128 characters)
  /// @param region AWS region for the user pool
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  CognitoAdminEnableUserRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters
  ///
  /// @throws    CognitoValidationException if any parameters are invalid
  void _validate() {
    // Pattern: [\w-]+_[0-9a-zA-Z]+
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (username.length > 128) {
      throw CognitoValidationException('username must be <= 128 characters.');
    }
  }

  /// Builds the request payload for the AWS API
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
  };

  /// Executes the AdminEnableUser request
  ///
  /// @return Future resolving to AdminEnableUserResult on success
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminEnableUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminEnableUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const CognitoAdminEnableUserResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminEnableUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminEnableUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminEnableUser unexpected status.',
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

    throw CognitoServiceException(
      'AdminEnableUser failed after retries. Last error: $lastError',
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
