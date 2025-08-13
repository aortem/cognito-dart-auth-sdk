// admin_list_user_auth_events_request.dart
// aortem_cognito_admin_list_user_auth_events_request.dart
//
// AdminListUserAuthEvents — Returns a history of user auth events and risks.
// Target: AWSCognitoIdentityProviderService.AdminListUserAuthEvents
//
// Provides functionality to retrieve authentication events for a specific user
// from Amazon Cognito, with support for pagination and automatic retries.

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Represents a single page of authentication events from Cognito.
///
/// Contains:
/// - [authEvents]: List of raw event maps in AuthEventType wire format
/// - [nextToken]: Token for fetching the next page, if available
class AortemCognitoAdminListUserAuthEventsPage {
  /// The list of authentication events for this page
  final List<Map<String, dynamic>> authEvents;

  /// Token for fetching the next page of results
  final String? nextToken;

  /// Creates a new page of authentication events
  const AortemCognitoAdminListUserAuthEventsPage({
    required this.authEvents,
    this.nextToken,
  });
}

/// Request wrapper for AdminListUserAuthEvents API.
///
/// Provides functionality to:
/// - Fetch a single page of authentication events
/// - Paginate through all events via streaming
/// - Retrieve all events in a single list
///
/// Notes:
/// - Pagination is handled via NextToken + MaxResults (0..60)
/// - A MaxResults of 0 means 60 (per AWS documentation)
/// - Success responses (200) contain AuthEvents array and optional NextToken
/// - Empty pages are allowed (no events, possibly with NextToken)
class AortemCognitoAdminListUserAuthEventsRequest {
  /// The ID of the user pool containing the user
  final String userPoolId;

  /// The username to fetch events for
  final String username;

  /// Maximum number of results per page (0-60, where 0 means 60)
  final int? maxResults;

  /// The AWS region where the user pool is located
  final String region;

  /// HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures
  final int maxRetries;

  /// Timeout duration for each request attempt
  final Duration requestTimeout;

  /// Creates a new authentication events request
  ///
  /// Validates parameters immediately and throws [AortemCognitoValidationException]
  /// if they are invalid.
  AortemCognitoAdminListUserAuthEventsRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.maxResults,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates the request parameters
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - userPoolId is empty or doesn't match expected pattern
  /// - username is empty
  /// - maxResults is outside 0-60 range
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
    if (maxResults != null && (maxResults! < 0 || maxResults! > 60)) {
      throw AortemCognitoValidationException(
        'maxResults must be between 0 and 60.',
      );
    }
  }

  /// Creates the payload for the API request
  Map<String, dynamic> _payload(String? nextToken) => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (maxResults != null) 'MaxResults': maxResults,
    if (nextToken != null && nextToken.isNotEmpty) 'NextToken': nextToken,
  };

  /// Fetches a single page of authentication events
  ///
  /// Parameters:
  /// - [nextToken]: Token for fetching the next page (optional)
  ///
  /// Returns:
  /// - [AortemCognitoAdminListUserAuthEventsPage] containing the events and next token
  ///
  /// Throws:
  /// - [AortemCognitoServiceException] if the request fails
  Future<AortemCognitoAdminListUserAuthEventsPage> listPage({
    String? nextToken,
  }) async {
    final payload = _payload(nextToken);

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
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          final body = res.jsonBody ?? const <String, dynamic>{};
          final events = (body['AuthEvents'] as List<dynamic>? ?? [])
              .whereType<Map>()
              .map((m) => Map<String, dynamic>.from(m as Map))
              .toList();
          final nt = body['NextToken'] as String?;
          return AortemCognitoAdminListUserAuthEventsPage(
            authEvents: events,
            nextToken: nt,
          );
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminListUserAuthEvents failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }
        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminListUserAuthEvents temporary failure.',
            statusCode: res.statusCode,
          );
        }
        throw AortemCognitoServiceException(
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

    throw AortemCognitoServiceException(
      'AdminListUserAuthEvents failed after retries. Last error: $lastError',
    );
  }

  /// Async generator that yields all pages of authentication events
  ///
  /// Automatically handles pagination by following the NextToken until
  /// all results are retrieved.
  Stream<AortemCognitoAdminListUserAuthEventsPage> paginate() async* {
    String? token;
    do {
      final page = await listPage(nextToken: token);
      yield page;
      token = page.nextToken;
    } while (token != null && token.isNotEmpty);
  }

  /// Convenience method to retrieve all authentication events in a single list
  ///
  /// Automatically handles pagination internally and returns a flattened list
  /// of all events across all pages.
  Future<List<Map<String, dynamic>>> listAll() async {
    final out = <Map<String, dynamic>>[];
    await for (final page in paginate()) {
      out.addAll(page.authEvents);
    }
    return out;
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
