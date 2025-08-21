// cognito_admin_delete_user_request.dart
//
// AdminDeleteUser — Deletes a user from the specified Cognito user pool.
// Target: AWSCognitoIdentityProviderService.AdminDeleteUser
//
// Depends on shared types:
// - AortemCognitoHttpClient (send(...) and/or post(...))
// - AortemCognitoValidationException
// - AortemCognitoServiceException

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// The result of a successful AdminDeleteUser operation.
///
/// This is essentially a marker class since AdminDeleteUser doesn't return
/// any data on success (204 No Content response from AWS).
class AortemCognitoAdminDeleteUserResult {
  /// Creates a new result instance.
  const AortemCognitoAdminDeleteUserResult();
}

/// A request to delete a user from a Cognito User Pool using admin privileges.
///
/// This implements the [AdminDeleteUser API](https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminDeleteUser.html)
/// with automatic retries for transient failures and proper error handling.
class AortemCognitoAdminDeleteUserRequest {
  /// The ID of the user pool where the user will be deleted.
  final String userPoolId;

  /// The username of the user to be deleted.
  final String username;

  /// The AWS region where the user pool is located.
  final String region;

  /// The HTTP client used to make the request.
  final AortemCognitoHttpClient httpClient;

  /// How many retries to attempt on transient failures (5xx/network errors).
  final int maxRetries;

  /// The timeout duration for each request attempt.
  final Duration requestTimeout;

  /// Creates a new AdminDeleteUser request.
  ///
  /// Validates parameters immediately and throws [AortemCognitoValidationException]
  /// if they are invalid.
  AortemCognitoAdminDeleteUserRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates the request parameters.
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - userPoolId is empty or doesn't match the expected pattern
  /// - username is empty or exceeds 128 characters
  void _validate() {
    // Pattern: [\w-]+_[0-9a-zA-Z]+
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
      throw AortemCognitoValidationException(
        'username must be <= 128 characters.',
      );
    }
  }

  /// Creates the payload for the AWS API request.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
  };

  /// Executes the AdminDeleteUser request.
  ///
  /// Returns a [Future] that completes with [AortemCognitoAdminDeleteUserResult]
  /// on success.
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if parameters are invalid
  /// - [AortemCognitoServiceException] if the request fails (including after retries)
  /// - Other platform/network exceptions if unrecoverable errors occur
  Future<AortemCognitoAdminDeleteUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminDeleteUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const AortemCognitoAdminDeleteUserResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminDeleteUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminDeleteUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminDeleteUser unexpected status.',
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
      'AdminDeleteUser failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying.
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
