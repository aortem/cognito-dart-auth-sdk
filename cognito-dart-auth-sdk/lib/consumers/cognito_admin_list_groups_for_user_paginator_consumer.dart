// admin_list_groups_for_user_paginator_consumer.dart
//    cognito_admin_list_groups_for_user_paginator_consumer.dart
//
// Consumer (builder) for the AdminListGroupsForUser paginator.
//
// Provides a fluent interface for paginating through all groups a user belongs to
// in a Cognito user pool, with options for both batch and streaming access.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_paginator_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for configuring the paginator builder
typedef CognitoAdminListGroupsForUserPaginatorFn =
    void Function(CognitoAdminListGroupsForUserPaginatorBuilder b);

/// Builder class for creating AdminListGroupsForUser paginated requests.
///
/// Provides a fluent interface to configure:
/// - User pool ID
/// - Username
/// - Page size limit
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminListGroupsForUserPaginatorBuilder()
///   .userPoolId('us-west-2_EXAMPLE')
///   .username('testuser')
///   .limit(25);
/// ```
class CognitoAdminListGroupsForUserPaginatorBuilder {
  String? _userPoolId;
  String? _username;
  int? _limit;

  /// Sets the user pool ID to query.
  ///
  /// The value will be trimmed of whitespace.
  CognitoAdminListGroupsForUserPaginatorBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the username to look up groups for.
  ///
  /// The value will be trimmed of whitespace.
  CognitoAdminListGroupsForUserPaginatorBuilder username(String v) {
    _username = v.trim();
    return this;
  }

  /// Sets the maximum number of groups to return per page.
  ///
  /// If not set, AWS defaults will be used.
  CognitoAdminListGroupsForUserPaginatorBuilder limit(int v) {
    _limit = v;
    return this;
  }

  /// Builds the paginated request with current configuration.
  ///
  /// Validates that required parameters (userPoolId and username) are set.
  /// Throws [CognitoValidationException] if validation fails.
  CognitoAdminListGroupsForUserPaginatorRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    return CognitoAdminListGroupsForUserPaginatorRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      limit: _limit,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class for paginating through a user's groups.
///
/// Provides two approaches:
/// 1. [runAll] - Fetches all groups at once
/// 2. [runPages] - Streams groups page by page
///
/// Example:
/// ```dart
/// final consumer =    CognitoAdminListGroupsForUserPaginatorConsumer(
///   region: 'us-west-2',
///   httpClient: client,
/// );
/// final allGroups = await consumer.runAll((b) => b
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..limit(25),
/// );
/// ```
class CognitoAdminListGroupsForUserPaginatorConsumer {
  /// The AWS region containing the user pool
  final String region;

  /// HTTP client for making requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for each request attempt
  final Duration requestTimeout;

  /// Creates a new paginator consumer
  CognitoAdminListGroupsForUserPaginatorConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Fetches all groups the user belongs to in a single list.
  ///
  /// Automatically handles pagination internally and returns a flattened list
  /// of all groups across all pages.
  Future<List<Map<String, dynamic>>> runAll(
    CognitoAdminListGroupsForUserPaginatorFn fn,
  ) async {
    final b = CognitoAdminListGroupsForUserPaginatorBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.fetchAll();
  }

  /// Streams groups page by page for memory-efficient processing.
  ///
  /// Yields each page of groups as it's received from AWS.
  /// Useful for large datasets or streaming scenarios.
  Stream<CognitoAdminListGroupsForUserPage> runPages(
    CognitoAdminListGroupsForUserPaginatorFn fn,
  ) async* {
    final b = CognitoAdminListGroupsForUserPaginatorBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    yield* req.paginate();
  }
}
