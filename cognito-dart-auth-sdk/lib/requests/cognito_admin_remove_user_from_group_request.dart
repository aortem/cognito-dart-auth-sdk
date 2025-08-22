
//    cognito_admin_remove_user_from_group_request.dart

//
// AdminRemoveUserFromGroup — Removes a user from a specific group in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminRemoveUserFromGroup
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

/// Represents the successful result of an AdminRemoveUserFromGroup operation.
///
/// This operation returns an empty response on success (HTTP 200), so this
/// class serves as a marker for successful completion without any additional data.
class CognitoAdminRemoveUserFromGroupResult {
  /// Creates a constant success result instance.
  const CognitoAdminRemoveUserFromGroupResult();
}

/// Request wrapper for AWS Cognito's AdminRemoveUserFromGroup operation.
///
/// This class handles the construction, validation, and execution of requests
/// to remove a user from a specific group in a Cognito user pool.
///
/// The operation requires administrator credentials and is typically used
/// in backend services rather than client applications.
class CognitoAdminRemoveUserFromGroupRequest {
  /// The ID of the user pool that contains the group and user.
  final String userPoolId;

  /// The username (or alias, or sub / federated username) to remove.
  final String username;

  /// The target group to remove the user from.
  final String groupName;

  /// AWS region, e.g. "us-west-2".
  final String region;

  /// SigV4-capable HTTP client abstraction.
  final CognitoHttpClient httpClient;

  /// Retries for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout (default: 20s).
  final Duration requestTimeout;

  /// Creates a new AdminRemoveUserFromGroup request instance.
  ///
  /// [userPoolId] - The Cognito user pool identifier (format: region_ID)
  /// [username] - The username to remove from the group
  /// [groupName] - The name of the group to remove the user from
  /// [region] - AWS region where the user pool is located
  /// [httpClient] - HTTP client configured for AWS SigV4 authentication
  /// [maxRetries] - Maximum number of retry attempts for transient failures
  /// [requestTimeout] - Timeout duration for the HTTP request
  ///
  /// Automatically validates parameters upon construction.
  CognitoAdminRemoveUserFromGroupRequest({
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

  /// Validates request parameters according to AWS Cognito requirements.
  ///
  /// Ensures that all required parameters are present and conform to
  /// AWS Cognito's format and length constraints.
  ///
  /// Throws [CognitoValidationException] if any validation fails.
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
    if (groupName.trim().isEmpty) {
      throw CognitoValidationException('groupName is required.');
    }
    if (groupName.length > 128) {
      throw CognitoValidationException('groupName must be <= 128 chars.');
    }
  }

  /// Constructs the JSON payload for the AdminRemoveUserFromGroup request.
  ///
  /// Returns a [Map] containing the required parameters formatted for
  /// AWS Cognito's JSON API (application/x-amz-json-1.1).
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    'GroupName': groupName,
  };

  /// Executes the AdminRemoveUserFromGroup operation.
  ///
  /// Performs the HTTP request to AWS Cognito with retry logic for
  /// transient failures and proper error handling for service errors.
  ///
  /// Returns a [Future] that completes with a success result on HTTP 200,
  /// or throws an [CognitoServiceException] on failure.
  ///
  /// Retry logic:
  /// - Retries on network timeouts, socket exceptions, and 5xx errors
  /// - Uses incremental backoff (200ms * attempt number)
  /// - Does not retry on 4xx errors (client errors)
  Future<CognitoAdminRemoveUserFromGroupResult> execute() async {
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
  return const CognitoAdminRemoveUserFromGroupResult();
}

if (res.statusCode >= 400 && res.statusCode < 500) {
  throw CognitoServiceException(
    'AdminRemoveUserFromGroup failed. Body: ${res.bodyString}',
    statusCode: res.statusCode,
  );
}

if (res.statusCode >= 500) {
  throw CognitoServiceException(
    'AdminRemoveUserFromGroup temporary failure.',
    statusCode: res.statusCode,
  );
}

throw CognitoServiceException(
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

    throw CognitoServiceException(
      'AdminRemoveUserFromGroup failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying.
  ///
  /// [e] - The error object to evaluate
  /// Returns [true] if the error appears to be transient (network issues,
  /// timeouts, or server-side 5xx errors), [false] otherwise.
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
