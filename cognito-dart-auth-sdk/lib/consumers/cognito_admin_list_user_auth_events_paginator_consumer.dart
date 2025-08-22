// admin_list_user_auth_events_paginator_consumer.dart
//    cognito_admin_list_user_auth_events_paginator_consumer.dart
//
// Consumer (builder) for AdminListUserAuthEvents paginator.
// Lets callers configure userPoolId/username via a closure and reuse region/client.
//
// Examples:
//
// // one page
// final consumer =    CognitoAdminListUserAuthEventsPaginatorConsumer(
//   region: 'us-west-2',
//   httpClient: client,
// );
// final page = await consumer.fetchPage((b) => b
//   ..userPoolId('us-west-2_EXAMPLE')
//   ..username('testuser'),
//   pageSize: 10,
// );
//
// // all pages
// final all = await consumer.fetchAll((b) => b
//   ..userPoolId('us-west-2_EXAMPLE')
//   ..username('testuser'),
//   pageSize: 25,
// );

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_user_auth_events_paginator_request.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a builder function that configures an AdminListUserAuthEvents request.
///
/// This function type allows callers to configure the user pool ID and username
/// using a fluent builder pattern.
typedef CognitoAdminListUserAuthEventsBuildFn =
    void Function(CognitoAdminListUserAuthEventsBuilder b);

/// Builder class for constructing AdminListUserAuthEvents paginator requests.
///
/// Provides a fluent interface for setting required parameters (userPoolId, username)
/// and building a configured request instance.
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminListUserAuthEventsBuilder();
/// builder
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser');
/// ```
class CognitoAdminListUserAuthEventsBuilder {
  String? _userPoolId;
  String? _username;

  /// Sets the user pool ID for the authentication events request.
  ///
  /// [v] - The Cognito user pool identifier (e.g., 'us-west-2_EXAMPLE')
  /// Returns the builder instance for method chaining.
  CognitoAdminListUserAuthEventsBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the username for the authentication events request.
  ///
  /// [v] - The username of the user whose authentication events are being queried
  /// Returns the builder instance for method chaining.
  CognitoAdminListUserAuthEventsBuilder username(String v) {
    _username = v.trim();
    return this;
  }

  /// Builds a configured AdminListUserAuthEvents paginator request.
  ///
  /// Validates that required parameters (userPoolId, username) are provided
  /// and returns a ready-to-use request instance.
  ///
  /// [region] - AWS region where the user pool is located
  /// [httpClient] - HTTP client for making requests to AWS Cognito
  /// [maxRetries] - Maximum number of retry attempts for failed requests
  /// [requestTimeout] - Timeout duration for individual requests
  ///
  /// Throws [CognitoValidationException] if required parameters are missing.
  CognitoAdminListUserAuthEventsPaginatorRequest build({
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

    return CognitoAdminListUserAuthEventsPaginatorRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class for paginating through Cognito user authentication events.
///
/// Provides a convenient way to fetch authentication events for a specific user
/// with reusable configuration (region, HTTP client, retry settings).
///
/// This class encapsulates the pagination logic and allows fetching either
/// single pages or all available pages of authentication events.
class CognitoAdminListUserAuthEventsPaginatorConsumer {
  /// AWS region where the Cognito user pool is located.
  final String region;

  /// HTTP client used for making requests to AWS Cognito service.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests.
  final int maxRetries;

  /// Timeout duration for individual HTTP requests.
  final Duration requestTimeout;

  /// Creates a new paginator consumer with the specified configuration.
  ///
  /// [region] - AWS region identifier (e.g., 'us-west-2')
  /// [httpClient] - Configured HTTP client for AWS requests
  /// [maxRetries] - Maximum retry attempts (default: 2)
  /// [requestTimeout] - Request timeout duration (default: 20 seconds)
  CognitoAdminListUserAuthEventsPaginatorConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Fetches a single page of user authentication events.
  ///
  /// [fn] - Builder function that configures userPoolId and username
  /// [pageSize] - Maximum number of events to return in this page
  /// [nextToken] - Pagination token for fetching subsequent pages
  ///
  /// Returns a [Future] that completes with a page of authentication events.
  Future<CognitoAdminListUserAuthEventsPage> fetchPage(
    CognitoAdminListUserAuthEventsBuildFn fn, {
    int? pageSize,
    String? nextToken,
  }) async {
    final b = CognitoAdminListUserAuthEventsBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.fetchPage(maxResults: pageSize, nextToken: nextToken);
  }

  /// Fetches all available pages of user authentication events.
  ///
  /// Automatically handles pagination to retrieve all events across multiple pages.
  ///
  /// [fn] - Builder function that configures userPoolId and username
  /// [pageSize] - Number of events to fetch per page (optional)
  /// [maxPages] - Maximum number of pages to fetch (optional, for limiting results)
  ///
  /// Returns a [Future] that completes with a list of all authentication events.
  Future<List<Map<String, dynamic>>> fetchAll(
    CognitoAdminListUserAuthEventsBuildFn fn, {
    int? pageSize,
    int? maxPages,
  }) async {
    final b = CognitoAdminListUserAuthEventsBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.fetchAll(pageSize: pageSize, maxPages: maxPages);
  }
}
