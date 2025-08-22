// cognito_admin_add_user_to_group_request.dart
//
// AdminAddUserToGroup — Adds an existing user to a specific group in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminAddUserToGroup
//
// Depends on shared types:
// -  CognitoHttpClient
// -  CognitoHttpResponse
// -  CognitoValidationException
// -  CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents a successful response from the AdminAddUserToGroup API.
///
/// Note: The AWS Cognito API returns an empty response on success (HTTP 200 with empty body).
/// This class exists for type safety and consistency in the SDK.
class CognitoAdminAddUserToGroupResult {
  /// Creates a success result instance.
  const CognitoAdminAddUserToGroupResult();
}

/// A request to add an existing user to a Cognito User Pool group using admin privileges.
///
/// This class handles:
/// - Validating request parameters
/// - Building the proper API payload
/// - Executing the request with automatic retries for transient failures
/// - Converting various error responses to appropriate exceptions
///
/// Example Usage:
/// ```dart
/// final request =  CognitoAdminAddUserToGroupRequest(
///   userPoolId: 'us-east-1_abc123',
///   username: 'testuser',
///   groupName: 'Admins',
///   region: 'us-east-1',
///   httpClient: myHttpClient,
/// );
///
/// try {
///   await request.execute();
///   print('User added to group successfully');
/// } on  CognitoValidationException catch (e) {
///   print('Validation error: ${e.message}');
/// } on  CognitoServiceException catch (e) {
///   print('Service error (${e.statusCode}): ${e.message}');
/// }
/// ```
class CognitoAdminAddUserToGroupRequest {
  /// The ID of the User Pool containing the user and group
  final String userPoolId;

  /// The username of the user to add to the group
  final String username;

  /// The name of the group to add the user to
  final String groupName;

  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient errors (default: 2)
  ///
  /// This means the request will be tried up to 3 times total (initial attempt + 2 retries)
  final int maxRetries;

  /// Timeout for each HTTP request to AWS (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new AdminAddUserToGroup request
  ///
  /// Parameters:
  /// - [userPoolId]: Required Cognito User Pool ID (format: region_id)
  /// - [username]: Required username to add to group
  /// - [groupName]: Required group name
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout per request (default 20 seconds)
  CognitoAdminAddUserToGroupRequest({
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

  /// Validates all request parameters before execution
  ///
  /// Throws [CognitoValidationException] if:
  /// - userPoolId is empty or invalid format
  /// - username is empty
  /// - groupName is empty or exceeds 128 characters
  void _validate() {
    if (userPoolId.trim().isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    // Cognito pool id pattern: [\w-]+_[0-9a-zA-Z]+
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (!poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is invalid. Expected pattern: [\\w-]+_[0-9a-zA-Z]+',
      );
    }

    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (groupName.trim().isEmpty) {
      throw CognitoValidationException('groupName is required.');
    }
    if (groupName.length > 128) {
      throw CognitoValidationException('groupName must be <= 128 chars.');
    }
  }

  /// Builds the request payload in the format expected by AWS Cognito
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    'GroupName': groupName,
  };

  /// Executes the AdminAddUserToGroup request
  ///
  /// Handles:
  /// - Automatic retries for transient failures
  /// - Exponential backoff between retries
  /// - Conversion of various error responses to appropriate exceptions
  ///
  /// Returns:
  /// - [CognitoAdminAddUserToGroupResult] on success
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for API failures
  Future<CognitoAdminAddUserToGroupResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminAddUserToGroup',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.0'},
        );

        // Success per docs: HTTP 200 with empty body {}
        if (res.statusCode == 200) {
          return const CognitoAdminAddUserToGroupResult();
        }

        // 4xx -> non-retryable service error
        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminAddUserToGroup failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        // 5xx -> transient
        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminAddUserToGroup temporary failure.',
            statusCode: res.statusCode,
          );
        }

        // Anything else unexpected
        throw CognitoServiceException(
          'AdminAddUserToGroup unexpected status.',
          statusCode: res.statusCode,
        );
      } catch (e) {
        lastError = e;

        final transient = _isTransient(e);
        if (!transient || attempt == maxRetries) break;

        // simple incremental backoff
        final delayMs = 200 * (attempt + 1);
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      } finally {
        attempt++;
      }
    }

    throw CognitoServiceException(
      'AdminAddUserToGroup failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying
  ///
  /// Returns true for:
  /// - Network connectivity issues (SocketException, TimeoutException)
  /// - 5xx server errors
  /// - Errors explicitly marked as "temporary"
  bool _isTransient(Object e) {
    // treat network/timeouts/our 5xx wrapper as transient
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
