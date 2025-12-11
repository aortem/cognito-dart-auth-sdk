//    cognito_admin_reset_user_password_request.dart
//
// AdminResetUserPassword — Begins a password reset for a user.
// Target: AWSCognitoIdentityProviderService.AdminResetUserPassword
//
// Success: HTTP 200 with empty body.
// Retries: transient (network/timeout/5xx) with small incremental backoff.
// Errors: 4xx =>    CognitoServiceException (non-retryable).
//
// Depends on shared types:
// -    CognitoHttpClient (send(...))
// -    CognitoValidationException
// -    CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents the successful result of an AdminResetUserPassword operation.
///
/// This is an empty success indicator since the AdminResetUserPassword API
/// returns an empty response body (HTTP 200) on success.
class CognitoAdminResetUserPasswordResult {
  const CognitoAdminResetUserPasswordResult();
}

/// Request class for performing admin-initiated user password resets in AWS Cognito.
///
/// This class encapsulates the AdminResetUserPassword API operation, which allows
/// administrators to reset user passwords without requiring the user's current password.
/// The operation triggers the Cognito password reset flow, typically sending a
/// verification code to the user's registered email or phone number.
///
/// Example:
/// ```dart
/// final request =    CognitoAdminResetUserPasswordRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   region: 'us-west-2',
///   httpClient: httpClient,
///   clientMetadata: {'source': 'admin-portal'},
/// );
///
/// final result = await request.execute();
/// ```
class CognitoAdminResetUserPasswordRequest {
  /// The ID of the user pool where you want to reset the user's password.
  final String userPoolId;

  /// The username or alias (or sub / federated username).
  final String username;

  /// Optional metadata passed to Lambda triggers (CustomMessage).
  final Map<String, String>? clientMetadata;

  /// AWS region, e.g. "us-west-2".
  final String region;

  /// SigV4-capable HTTP client abstraction.
  final CognitoHttpClient httpClient;

  /// Retries for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout (default: 20s).
  final Duration requestTimeout;

  /// Creates a new AdminResetUserPassword request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID where the user exists
  /// - [username]: Required - The username of the user to reset
  /// - [region]: Required - AWS region where the User Pool is located
  /// - [httpClient]: Required - HTTP client for making authenticated requests
  /// - [clientMetadata]: Optional - Additional data for Lambda triggers
  /// - [maxRetries]: Optional - Maximum retry attempts for transient failures
  /// - [requestTimeout]: Optional - Timeout duration for the HTTP request
  ///
  /// Throws [CognitoValidationException] if parameters are invalid.
  CognitoAdminResetUserPasswordRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.clientMetadata,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates request parameters according to AWS Cognito requirements.
  ///
  /// Performs basic validation to catch common errors before making the
  /// network request. This includes checking User Pool ID format, username
  /// requirements, and client metadata constraints.
  ///
  /// Throws [CognitoValidationException] if validation fails.
  void _validate() {
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
      throw CognitoValidationException('username must be <= 128 chars.');
    }
    if (clientMetadata != null) {
      for (final e in clientMetadata!.entries) {
        if (e.key.isEmpty) {
          throw CognitoValidationException(
            'clientMetadata keys must be non-empty.',
          );
        }
      }
    }
  }

  /// Constructs the JSON payload for the AdminResetUserPassword API call.
  ///
  /// Returns a Map containing the required UserPoolId and Username parameters,
  /// along with optional ClientMetadata if provided.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (clientMetadata != null) 'ClientMetadata': clientMetadata,
  };

  /// Executes the AdminResetUserPassword API request.
  ///
  /// This method:
  /// 1. Validates parameters
  /// 2. Constructs the appropriate JSON payload
  /// 3. Signs and sends the request using SigV4 authentication
  /// 4. Handles retries for transient failures with incremental backoff
  /// 5. Parses and returns the result or appropriate exceptions
  ///
  /// Returns:
  /// A Future that completes with [   CognitoAdminResetUserPasswordResult]
  /// on successful password reset initiation.
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for AWS service errors (4xx/5xx)
  /// - Other exceptions for network failures or unexpected errors
  Future<CognitoAdminResetUserPasswordResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminResetUserPassword',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const CognitoAdminResetUserPasswordResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminResetUserPassword failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminResetUserPassword temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminResetUserPassword unexpected status.',
          statusCode: res.statusCode,
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
      'AdminResetUserPassword failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying.
  ///
  /// Transient errors include network timeouts, socket exceptions, and
  /// server-side 5xx errors that might be resolved by retrying.
  ///
  /// Parameters:
  /// - [e]: The exception to check
  ///
  /// Returns:
  /// true if the error is transient and retryable, false otherwise
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
