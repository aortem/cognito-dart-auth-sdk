// cognito_admin_delete_user_attributes_request.dart
//
// AdminDeleteUserAttributes — Deletes selected attributes from a user.
// Target: AWSCognitoIdentityProviderService.AdminDeleteUserAttributes
//
// Depends on shared types:
// - AortemCognitoHttpClient (send(...) and/or post(...))
// - AortemCognitoValidationException
// - AortemCognitoServiceException

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// The result of a successful AdminDeleteUserAttributes operation.
///
/// This is essentially a marker class since AdminDeleteUserAttributes doesn't return
/// any data on success (204 No Content response from AWS).
class AortemCognitoAdminDeleteUserAttributesResult {
  /// Creates a new result instance.
  const AortemCognitoAdminDeleteUserAttributesResult();
}

/// A request to delete specific attributes from a Cognito user using admin privileges.
///
/// This implements the [AdminDeleteUserAttributes API](https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminDeleteUserAttributes.html)
/// with automatic retries for transient failures and proper error handling.
///
/// Allows administrators to remove specific attributes from a user's profile.
class AortemCognitoAdminDeleteUserAttributesRequest {
  /// The ID of the user pool containing the user
  final String userPoolId;

  /// The username of the user whose attributes will be deleted
  final String username;

  /// List of attribute names to delete (standard or custom attributes)
  final List<String> userAttributeNames;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client used to make the request
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures
  final int maxRetries;

  /// Timeout duration for each request attempt
  final Duration requestTimeout;

  /// Creates a new AdminDeleteUserAttributes request.
  ///
  /// Validates parameters immediately and throws [AortemCognitoValidationException]
  /// if they are invalid.
  ///
  /// Parameters:
  /// - [userPoolId]: Required user pool ID (must match pattern [\w-]+_[0-9a-zA-Z]+)
  /// - [username]: Required username (1-128 characters)
  /// - [userAttributeNames]: Required list of attribute names to delete (1-32 items)
  /// - [region]: Required AWS region identifier
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Request timeout duration (default: 20 seconds)
  AortemCognitoAdminDeleteUserAttributesRequest({
    required this.userPoolId,
    required this.username,
    required this.userAttributeNames,
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
  /// - userAttributeNames is empty or has more than 32 items
  /// - any attribute name is empty
  void _validate() {
    // Pool ID pattern: [\w-]+_[0-9a-zA-Z]+
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

    if (userAttributeNames.isEmpty) {
      throw AortemCognitoValidationException(
        'At least one attribute name must be provided.',
      );
    }
    if (userAttributeNames.length > 32) {
      throw AortemCognitoValidationException(
        'No more than 32 attribute names may be provided.',
      );
    }
    for (final name in userAttributeNames) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw AortemCognitoValidationException(
          'Attribute names must be non-empty strings.',
        );
      }
      // Note: For custom attributes, ensure they include the 'custom:' prefix
      // AWS requires this prefix for custom attributes
    }
  }

  /// Creates the payload for the AWS API request.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    'UserAttributeNames': userAttributeNames,
  };

  /// Executes the AdminDeleteUserAttributes request.
  ///
  /// Returns a [Future] that completes with [AortemCognitoAdminDeleteUserAttributesResult]
  /// on success.
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if parameters are invalid
  /// - [AortemCognitoServiceException] if the request fails (including after retries)
  /// - Other platform/network exceptions if unrecoverable errors occur
  Future<AortemCognitoAdminDeleteUserAttributesResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminDeleteUserAttributes',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const AortemCognitoAdminDeleteUserAttributesResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminDeleteUserAttributes failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminDeleteUserAttributes temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminDeleteUserAttributes unexpected status.',
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
      'AdminDeleteUserAttributes failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying.
  ///
  /// Checks for common transient failure patterns in the error string:
  /// - 'temporary' indicator
  /// - Network-related exceptions
  /// - 5xx server errors
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
