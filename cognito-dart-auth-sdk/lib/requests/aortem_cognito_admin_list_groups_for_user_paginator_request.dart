// admin_list_groups_for_user_paginator_request.dart
// aortem_cognito_admin_list_groups_for_user_paginator_request.dart
//
// Paginator for AdminListGroupsForUser operation that handles automatic
// pagination using NextToken and Limit parameters.
// Calls the same AWS target: AWSCognitoIdentityProviderService.AdminListGroupsForUser

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Represents a single page of groups returned by the paginator.
class AortemCognitoAdminListGroupsForUserPage {
  /// The list of groups in this page
  final List<Map<String, dynamic>> groups;

  /// The pagination token for the next page, if available
  final String? nextToken;

  const AortemCognitoAdminListGroupsForUserPage({
    required this.groups,
    this.nextToken,
  });
}

/// Paginator for AdminListGroupsForUser operation.
///
/// Handles automatic pagination through all groups a user belongs to,
/// abstracting away the need to manually manage NextToken values.
///
/// Example Usage:
/// ```dart
/// // Get all groups at once
/// final pager = AortemCognitoAdminListGroupsForUserPaginatorRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   region: 'us-west-2',
///   httpClient: client,
///   limit: 25, // optional (0..60)
/// );
///
/// // Option 1: Fetch all groups in one call
/// final allGroups = await pager.fetchAll();
/// print('User belongs to ${allGroups.length} groups');
///
/// // Option 2: Process pages as they arrive
/// await for (final page in pager.paginate()) {
///   print('Page contains ${page.groups.length} groups');
///   if (page.nextToken != null) {
///     print('More groups available');
///   }
/// }
/// ```
class AortemCognitoAdminListGroupsForUserPaginatorRequest {
  /// The ID of the user pool containing the user
  final String userPoolId;

  /// The username whose groups should be listed
  final String username;

  /// Maximum number of groups to return per page (0-60)
  final int? limit;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new paginator instance.
  ///
  /// Parameters:
  /// - [userPoolId]: Required Cognito User Pool ID
  /// - [username]: Required username to list groups for
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [limit]: Optional maximum number of groups per page (0-60)
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout per request (default 20 seconds)
  AortemCognitoAdminListGroupsForUserPaginatorRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.limit,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters against AWS constraints.
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if any parameters are invalid
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
    if (limit != null && (limit! < 0 || limit! > 60)) {
      throw AortemCognitoValidationException('limit must be between 0 and 60.');
    }
  }

  /// Builds the API request payload for a specific page.
  Map<String, dynamic> _payload(String? nextToken) => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (limit != null) 'Limit': limit,
    if (nextToken != null && nextToken.isNotEmpty) 'NextToken': nextToken,
  };

  /// Fetches all groups across all pages and returns them as a single list.
  ///
  /// Returns:
  /// - A flattened list containing all groups the user belongs to
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid parameters
  /// - [AortemCognitoServiceException] for API failures
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final out = <Map<String, dynamic>>[];
    await for (final page in paginate()) {
      out.addAll(page.groups);
    }
    return out;
  }

  /// Async generator that yields pages of groups until all results are exhausted.
  ///
  /// Yields:
  /// - [AortemCognitoAdminListGroupsForUserPage] objects containing groups and pagination token
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid parameters
  /// - [AortemCognitoServiceException] for API failures
  Stream<AortemCognitoAdminListGroupsForUserPage> paginate() async* {
    String? next;
    do {
      final page = await _single(next);
      yield page;
      next = page.nextToken;
    } while (next != null && next.isNotEmpty);
  }

  /// Fetches a single page of results.
  Future<AortemCognitoAdminListGroupsForUserPage> _single(
    String? nextToken,
  ) async {
    final payload = _payload(nextToken);

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
          final groups = (body['Groups'] as List<dynamic>? ?? [])
              .whereType<Map>()
              .map((m) => Map<String, dynamic>.from(m as Map))
              .toList();
          final nt = body['NextToken'] as String?;
          return AortemCognitoAdminListGroupsForUserPage(
            groups: groups,
            nextToken: nt,
          );
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminListGroupsForUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }
        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminListGroupsForUser temporary failure.',
            statusCode: res.statusCode,
          );
        }
        throw AortemCognitoServiceException(
          'AdminListGroupsForUser unexpected status.',
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
