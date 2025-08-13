// admin_remove_user_from_group_request.dart
// cognito_admin_remove_user_from_group_request.dart
//
// AdminRemoveUserFromGroup — Removes a user from a specific group in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminRemoveUserFromGroup
//
// This request wrapper handles the removal of users from Cognito groups with:
// - Parameter validation
// - Automatic retries for transient failures
// - Proper error handling
// - Configurable timeout and retry behavior

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// Represents the successful result of removing a user from a group.
///
/// This is essentially a marker class since the operation returns no data
/// on success (200 OK with empty body).
class AortemCognitoAdminRemoveUserFromGroupResult {
  /// Creates a new result instance.
  const AortemCognitoAdminRemoveUserFromGroupResult();
}

/// Request wrapper for AdminRemoveUserFromGroup API operation.
///
/// Handles the removal of a user from a Cognito user pool group with:
/// - Parameter validation
/// - Automatic retries with incremental backoff
/// - Proper error classification (retryable vs non-retryable)
///
/// Behavior:
/// - Success: HTTP 200 with empty body
/// - Retries: Automatic for transient failures (network/timeout/5xx)
/// - Errors: 4xx results in AortemCognitoServiceException (non-retryable)
class AortemCognitoAdminRemoveUserFromGroupRequest {
  /// The ID of the user pool that contains the group and user
  final String userPoolId;

  /// The username (or alias, or sub/federated username) to remove
  final String username;

  /// The target group to remove the user from
  final String groupName;

  /// AWS region where the user pool is located (e.g. "us-west-2")
  final String region;

  /// HTTP client configured for SigV4 signing
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new request instance with the given parameters
  ///
  /// Immediately validates parameters and throws [AortemCognitoValidationException]
  /// if they are invalid.
  AortemCognitoAdminRemoveUserFromGroupRequest({
    required this.userPoolId,
    required this.username,
    required this.groupName,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates request parameters according to AWS requirements
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - userPoolId is empty or doesn't match expected pattern
  /// - username is empty or exceeds 128 characters
  /// - groupName is empty or exceeds 128 characters
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    if (username.length > 128) {
      throw AortemCognitoValidationException('username must be <= 128 chars.');
    }
    if (groupName.trim().isEmpty) {
      throw AortemCognitoValidationException('groupName is required.');
    }
    if (groupName.length > 128) {
      throw AortemCognitoValidationException('groupName must be <= 128 chars.');
    }
  }

  /// Creates the API request payload
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    'GroupName': groupName,
  };

  /// Executes the AdminRemoveUserFromGroup API call
  ///
  /// Returns:
  /// - [AortemCognitoAdminRemoveUserFromGroupResult] on success
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if parameters are invalid
  /// - [AortemCognitoServiceException] if the API call fails
  ///   (after retries for transient failures)
  Future<AortemCognitoAdminRemoveUserFromGroupResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminRemoveUserFromGroup',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const AortemCognitoAdminRemoveUserFromGroupResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminRemoveUserFromGroup failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminRemoveUserFromGroup temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminRemoveUserFromGroup unexpected status.',
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

    throw AortemCognitoServiceException(
      'AdminRemoveUserFromGroup failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
