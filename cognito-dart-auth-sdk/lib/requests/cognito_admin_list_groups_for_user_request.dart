// admin_list_groups_for_user_request.dart
//    cognito_admin_list_groups_for_user_request.dart
//
// AdminListGroupsForUser — Lists the groups that a user belongs to in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminListGroupsForUser
//
// Depends on shared types:
// -    CognitoHttpClient
// -    CognitoValidationException
// -    CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents the result of a successful AdminListGroupsForUser request.
///
/// Contains the list of groups the user belongs to and an optional pagination token
/// for retrieving additional results.
class CognitoAdminListGroupsForUserResult {
  /// The list of groups, each represented as a map of group attributes.
  ///
  /// Each group contains properties like:
  /// - GroupName: The name of the group
  /// - UserPoolId: The user pool ID
  /// - Description: Group description
  /// - RoleArn: IAM role associated with the group
  /// - Precedence: Precedence value for the group
  /// - LastModifiedDate: When the group was last modified
  /// - CreationDate: When the group was created
  final List<Map<String, dynamic>> groups;

  /// An opaque token for paginating through multiple pages of results.
  ///
  /// Will be null when there are no more pages available.
  final String? nextToken;

  ///

  const CognitoAdminListGroupsForUserResult({
    required this.groups,
    this.nextToken,
  });

  /// Creates a result instance from the raw API response JSON.
  factory CognitoAdminListGroupsForUserResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final items = (json['Groups'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();

    return CognitoAdminListGroupsForUserResult(
      groups: items,
      nextToken: json['NextToken'] as String?,
    );
  }
}

/// Request wrapper for AdminListGroupsForUser API operation.
///
/// This class handles listing the groups for a specific user in a Cognito user pool,
/// with support for pagination.
///
/// Example Usage:
/// ```dart
/// final req =    CognitoAdminListGroupsForUserRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   region: 'us-west-2',
///   httpClient: client,
///   limit: 10,
/// );
///
/// try {
///   final res = await req.execute();
///   print('User belongs to ${res.groups.length} groups');
///   if (res.nextToken != null) {
///     print('More groups available with pagination token');
///   }
/// } on    CognitoValidationException catch (e) {
///   print('Validation error: ${e.message}');
/// } on    CognitoServiceException catch (e) {
///   print('Service error (${e.statusCode}): ${e.message}');
/// }
/// ```
class CognitoAdminListGroupsForUserRequest {
  /// The ID of the user pool containing the user
  final String userPoolId;

  /// The username whose groups should be listed
  final String username;

  /// Maximum number of groups to return (0-60, AWS max is 60)
  final int? limit;

  /// Token for paginating through multiple pages of results
  final String? nextToken;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new AdminListGroupsForUser request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required Cognito User Pool ID
  /// - [username]: Required username to list groups for
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [limit]: Optional maximum number of groups to return (0-60)
  /// - [nextToken]: Optional token for paginated results
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout per request (default 20 seconds)
  CognitoAdminListGroupsForUserRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.limit,
    this.nextToken,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters against AWS constraints.
  ///
  /// Throws:
  /// - [CognitoValidationException] if any parameters are invalid
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
    if (limit != null && (limit! < 0 || limit! > 60)) {
      throw CognitoValidationException('limit must be between 0 and 60.');
    }
    if (nextToken != null) {
      if (nextToken!.isEmpty || RegExp(r'^\s+$').hasMatch(nextToken!)) {
        throw CognitoValidationException(
          'nextToken must be a non-empty, non-whitespace string.',
        );
      }
    }
  }

  /// Builds the API request payload.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (limit != null) 'Limit': limit,
    if (nextToken != null) 'NextToken': nextToken,
  };

  /// Executes the AdminListGroupsForUser request.
  ///
  /// Handles:
  /// - Automatic retries for transient failures
  /// - Error response conversion
  /// - Response parsing
  ///
  /// Returns:
  /// - [   CognitoAdminListGroupsForUserResult] containing groups and pagination token
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for API failures
  Future<CognitoAdminListGroupsForUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminListGroupsForUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          final body = res.jsonBody ?? const <String, dynamic>{};
          return CognitoAdminListGroupsForUserResult.fromJson(body);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminListGroupsForUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminListGroupsForUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminListGroupsForUser unexpected status.',
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
      'AdminListGroupsForUser failed after retries. Last error: $lastError',
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
