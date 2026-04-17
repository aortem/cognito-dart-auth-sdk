// admin_list_user_auth_events_paginator_request.dart
//cognito_admin_list_user_auth_events_paginator_request.dart
//
// AdminListUserAuthEvents — Paginator over a user's auth events & risk signals.
// AWS Target: AWSCognitoIdentityProviderService.AdminListUserAuthEvents
//
// This class fetches *pages* with optional MaxResults and NextToken, and
// exposes:
//   - fetchPage(...) -> one page
//   - fetchAll(...)  -> pulls all pages (with optional cap)
//
// Success: HTTP 200 JSON with { AuthEvents: [...], NextToken? }.
// Retries: transient (network/timeout/5xx) with small incremental backoff.
// Errors: 4xx =>   CognitoServiceException (non-retryable).
//
// Depends on shared types:
// -   CognitoHttpClient (send(...))
// -   CognitoValidationException
// -   CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents a single page of authentication events from AdminListUserAuthEvents.
///
/// This class encapsulates the results of a paginated authentication events query,
/// containing both the events data and pagination information for fetching
/// subsequent pages if available.
class CognitoAdminListUserAuthEventsPage {
  /// Raw event objects as returned by Cognito (maps).
  ///
  /// Each event contains detailed information about an authentication attempt,
  /// including timestamps, risk assessment data, device information, and
  /// authentication outcome.
  final List<Map<String, dynamic>> authEvents;

  /// Next token for subsequent page (null if last page).
  ///
  /// This token is used to retrieve the next page of results in a paginated
  /// query. If null, it indicates that this is the last page of results.
  final String? nextToken;

  /// Creates a new page instance with authentication events and pagination token.
  ///
  /// Parameters:
  /// - [authEvents]: Required - List of authentication event data
  /// - [nextToken]: Required - Pagination token for next page (null for last page)
  CognitoAdminListUserAuthEventsPage({
    required this.authEvents,
    required this.nextToken,
  });
}

/// Paginator request class for AdminListUserAuthEvents API operation.
///
/// This class provides a paginated interface to retrieve a user's authentication
/// events and risk signals from AWS Cognito. It supports both single-page
/// fetching and automatic retrieval of all pages with optional safety limits.
///
/// Authentication events include information about successful and failed
/// authentication attempts, risk assessments, device information, and
/// geographical data useful for security monitoring and analysis.
///
/// Example:
/// ```dart
/// final paginator =   CognitoAdminListUserAuthEventsPaginatorRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   region: 'us-west-2',
///   httpClient: httpClient,
/// );
///
/// // Fetch a single page
/// final page = await paginator.fetchPage(maxResults: 50);
///
/// // Fetch all pages with safety limits
/// final allEvents = await paginator.fetchAll(pageSize: 50, maxPages: 10);
/// ```
class CognitoAdminListUserAuthEventsPaginatorRequest {
  /// The ID of the user pool where the user exists.
  ///
  /// Must be a valid Cognito User Pool ID in the format: `region_randomId`
  /// Example: "us-west-2_EXAMPLE"
  final String userPoolId;

  /// Target username (or alias/sub/federated username).
  ///
  /// The username of the user whose authentication events are being retrieved.
  final String username;

  /// AWS region where the User Pool is located (e.g., "us-west-2").
  final String region;

  /// SigV4-capable HTTP client for making authenticated requests to AWS.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout duration (default: 20 seconds).
  final Duration requestTimeout;

  /// Creates a new AdminListUserAuthEvents paginator request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [username]: Required - The username of the user
  /// - [region]: Required - AWS region identifier
  /// - [httpClient]: Required - HTTP client for making requests
  /// - [maxRetries]: Optional - Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional - Request timeout (default: 20 seconds)
  ///
  /// Throws [  CognitoValidationException] if parameters are invalid.
  CognitoAdminListUserAuthEventsPaginatorRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates request parameters according to AWS Cognito requirements.
  ///
  /// Performs validation of User Pool ID format and username requirements.
  ///
  /// Throws [  CognitoValidationException] if validation fails.
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
  }

  /// Constructs the JSON payload for the AdminListUserAuthEvents API call.
  ///
  /// Parameters:
  /// - [maxResults]: Optional - Maximum number of results per page (0-60)
  /// - [nextToken]: Optional - Pagination token for fetching specific page
  ///
  /// Returns:
  /// A Map containing the request parameters formatted for the AWS Cognito API
  Map<String, dynamic> _payload({int? maxResults, String? nextToken}) =>
      <String, dynamic>{
        'UserPoolId': userPoolId,
        'Username': username,
        if (maxResults case final value?) 'MaxResults': value,
        if (nextToken case final value? when value.isNotEmpty)
          'NextToken': value,
      };

  /// Fetch **one page** of authentication events.
  ///
  /// This method retrieves a single page of authentication events with optional
  /// control over page size and pagination token.
  ///
  /// Parameters:
  /// - [maxResults]: Optional - Number of events to return per page (0-60)
  /// - [nextToken]: Optional - Pagination token for fetching specific page
  ///
  /// Returns:
  /// A Future that completes with [  CognitoAdminListUserAuthEventsPage]
  /// containing the events and pagination information.
  ///
  /// Throws:
  /// - [  CognitoValidationException] for invalid parameters
  /// - [  CognitoServiceException] for AWS service errors
  /// - Other exceptions for network failures or unexpected errors
  Future<CognitoAdminListUserAuthEventsPage> fetchPage({
    int? maxResults,
    String? nextToken,
  }) async {
    final payload = _payload(maxResults: maxResults, nextToken: nextToken);

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminListUserAuthEvents',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application-x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          final body = res.jsonBody ?? <String, dynamic>{};
          final eventsRaw = body['AuthEvents'];
          final token = body['NextToken'] as String?;
          final list = (eventsRaw is List)
              ? eventsRaw
                    .map<Map<String, dynamic>>(
                      (e) => (e as Map).cast<String, dynamic>(),
                    )
                    .toList()
              : <Map<String, dynamic>>[];
          return CognitoAdminListUserAuthEventsPage(
            authEvents: list,
            nextToken: token,
          );
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminListUserAuthEvents failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminListUserAuthEvents temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminListUserAuthEvents unexpected status.',
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
      'AdminListUserAuthEvents failed after retries. Last error: $lastError',
    );
  }

  /// Fetch **all pages** of authentication events until `NextToken` is absent.
  ///
  /// This method automatically handles pagination to retrieve all available
  /// authentication events for the user, with optional safety limits to
  /// prevent excessive API calls.
  ///
  /// Parameters:
  /// - [pageSize]: Optional per-page MaxResults (0..60 per AWS docs; 0 treated as "default 60")
  /// - [maxPages]: Optional safety cap to stop early after N pages
  ///
  /// Returns:
  /// A Future that completes with a List containing all authentication events
  /// across all retrieved pages.
  ///
  /// Throws:
  /// - [  CognitoValidationException] for invalid parameters
  /// - [  CognitoServiceException] for AWS service errors
  /// - Other exceptions for network failures or unexpected errors
  Future<List<Map<String, dynamic>>> fetchAll({
    int? pageSize,
    int? maxPages,
  }) async {
    final all = <Map<String, dynamic>>[];
    String? token;
    var fetchedPages = 0;

    while (true) {
      if (maxPages != null && fetchedPages >= maxPages) break;

      final page = await fetchPage(maxResults: pageSize, nextToken: token);
      all.addAll(page.authEvents);
      fetchedPages++;

      if (page.nextToken == null || page.nextToken!.isEmpty) break;
      token = page.nextToken;
    }

    return all;
  }

  /// Determines if an error is transient and worth retrying.
  ///
  /// Transient errors include network timeouts, socket exceptions, and
  /// server-side 5xx errors that might be resolved by retrying.
  ///
  /// Parameters:
  /// - [e]: The exception to check
  ///
  /// Returns:
  /// true if the error is transient and retryable, false otherwise
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
