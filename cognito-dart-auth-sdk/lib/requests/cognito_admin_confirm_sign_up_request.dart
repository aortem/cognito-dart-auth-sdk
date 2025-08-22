/// AdminConfirmSignUp — Confirms a user's sign-up as an administrator.
///
/// This request confirms user registration without requiring verification,
/// typically used for administrative purposes.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminConfirmSignUp.html
library _cognito_admin_confirm_sign_up_request;

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart'
    show CognitoHttpClient;

/// Result container for successful AdminConfirmSignUp operations.
///
/// The AWS API returns an empty response on success, so this serves
/// as a type-safe marker for completion.
class CognitoAdminConfirmSignUpResult {
  /// Creates a new successful result instance
  const CognitoAdminConfirmSignUpResult();
}

/// Request class for AdminConfirmSignUp API operation.
///
/// This allows administrators to confirm user registrations without
/// requiring verification codes.
class CognitoAdminConfirmSignUpRequest {
  /// The user pool ID for the user pool where the user is registered
  /// Format: [\w-]+_[0-9a-zA-Z]+
  final String userPoolId;

  /// The username of the user to be confirmed
  final String username;

  /// Optional metadata to associate with the confirmation operation
  ///
  /// This can be used to pass custom key-value pairs to Lambda triggers
  final Map<String, String>? clientMetadata;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures
  final int maxRetries;

  /// Timeout duration for the HTTP request
  final Duration requestTimeout;

  /// Creates a new AdminConfirmSignUp request
  ///
  /// @param userPoolId Required user pool ID
  /// @param username Required username to confirm
  /// @param region AWS region for the user pool
  /// @param httpClient Configured HTTP client
  /// @param clientMetadata Optional metadata for Lambda triggers
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  CognitoAdminConfirmSignUpRequest({
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

  /// Validates the request parameters before execution
  ///
  /// @throws    CognitoValidationException if any parameters are invalid
  void _validate() {
    // Pool ID pattern: [\w-]+_[0-9a-zA-Z]+
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (clientMetadata != null) {
      // Basic sanity: keys/values non-null (Map<String,String> already enforces)
      // You can add size limits if you want (docs allow very large).
      for (final entry in clientMetadata!.entries) {
        if (entry.key.isEmpty) {
          throw CognitoValidationException(
            'clientMetadata keys must be non-empty.',
          );
        }
      }
    }
  }

  /// Builds the request payload for the AWS API
  ///
  /// @return Map containing the structured request data
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (clientMetadata != null) 'ClientMetadata': clientMetadata,
  };

  /// Executes the AdminConfirmSignUp request
  ///
  /// @return Future resolving to    CognitoAdminConfirmSignUpResult on success
  /// @throws    CognitoServiceException for API failures
  /// @throws    CognitoValidationException for invalid parameters
  Future<CognitoAdminConfirmSignUpResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminConfirmSignUp',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const CognitoAdminConfirmSignUpResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminConfirmSignUp failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminConfirmSignUp temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminConfirmSignUp unexpected status.',
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
      'AdminConfirmSignUp failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying
  ///
  /// @param e The error object to evaluate
  /// @return true if the error appears transient
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
