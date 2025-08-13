// admin_list_user_auth_events_consumer.dart
// aortem_cognito_admin_list_user_auth_events_consumer.dart
//
// Consumer (builder) for AdminListUserAuthEvents.
//
// Provides a fluent interface for listing authentication events for a specific user
// in Amazon Cognito, with support for both batch retrieval and paginated streaming.

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_list_user_auth_events_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';

/// Function type for configuring the authentication events builder.
///
/// Used to provide a fluent interface for building AdminListUserAuthEvents requests.
typedef AortemCognitoAdminListUserAuthEventsFn =
    void Function(AortemCognitoAdminListUserAuthEventsBuilder b);

/// Builder class for creating AdminListUserAuthEvents requests.
///
/// Provides a fluent interface to configure:
/// - User pool ID
/// - Username
/// - Maximum results per page (0-60)
///
/// Example:
/// ```dart
/// final builder = AortemCognitoAdminListUserAuthEventsBuilder()
///   .userPoolId('us-west-2_EXAMPLE')
///   .username('testuser')
///   .maxResults(25);
/// ```
class AortemCognitoAdminListUserAuthEventsBuilder {
  String? _userPoolId;
  String? _username;
  int? _maxResults; // 0..60

  /// Sets the user pool ID where the authentication events will be queried.
  ///
  /// The value will be trimmed of whitespace.
  AortemCognitoAdminListUserAuthEventsBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the username to query authentication events for.
  ///
  /// The value will be trimmed of whitespace.
  AortemCognitoAdminListUserAuthEventsBuilder username(String v) {
    _username = v.trim();
    return this;
  }

  /// Sets the maximum number of events to return per page (0-60).
  ///
  /// If not set, AWS defaults will be used.
  AortemCognitoAdminListUserAuthEventsBuilder maxResults(int v) {
    _maxResults = v;
    return this;
  }

  /// Builds the authentication events request with current configuration.
  ///
  /// Validates that required parameters (userPoolId and username) are set.
  /// Throws [AortemCognitoValidationException] if validation fails.
  AortemCognitoAdminListUserAuthEventsRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    if (up.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    return AortemCognitoAdminListUserAuthEventsRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxResults: _maxResults,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class for listing user authentication events.
///
/// Provides two approaches to retrieve authentication events:
/// 1. [runAll] - Fetches all events in a single list
/// 2. [runPages] - Streams events page by page
///
/// Example:
/// ```dart
/// final consumer = AortemCognitoAdminListUserAuthEventsConsumer(
///   region: 'us-west-2',
///   httpClient: client,
/// );
/// final allEvents = await consumer.runAll((b) => b
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..maxResults(25),
/// );
/// ```
class AortemCognitoAdminListUserAuthEventsConsumer {
  /// The AWS region containing the user pool
  final String region;

  /// HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for each request attempt
  final Duration requestTimeout;

  /// Creates a new authentication events consumer
  AortemCognitoAdminListUserAuthEventsConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Fetches all authentication events for the user in a single list.
  ///
  /// Automatically handles pagination internally and returns a flattened list
  /// of all events across all pages.
  Future<List<Map<String, dynamic>>> runAll(
    AortemCognitoAdminListUserAuthEventsFn fn,
  ) async {
    final b = AortemCognitoAdminListUserAuthEventsBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.listAll();
  }

  /// Streams authentication events page by page for memory-efficient processing.
  ///
  /// Yields each page of events as it's received from AWS.
  /// Useful for large datasets or streaming scenarios.
  Stream<AortemCognitoAdminListUserAuthEventsPage> runPages(
    AortemCognitoAdminListUserAuthEventsFn fn,
  ) async* {
    final b = AortemCognitoAdminListUserAuthEventsBuilder();
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
