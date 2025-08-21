// admin_list_groups_for_user_consumer.dart
// cognito_admin_list_groups_for_user_consumer.dart
//
// Consumer-style facade for AdminListGroupsForUser operation.
// Provides a fluent builder interface for listing groups a user belongs to
// in a Cognito user pool using admin privileges.

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

/// Functional interface for configuring AdminListGroupsForUser requests via builder.
///
/// Used with [AortemCognitoAdminListGroupsForUserConsumer.run] to dynamically
/// build group listing requests before sending them to Cognito.
typedef AortemCognitoAdminListGroupsForUserConsumerFn =
    void Function(AortemCognitoAdminListGroupsForUserBuilder b);

/// Fluent builder for constructing AdminListGroupsForUser requests.
///
/// Provides a chainable interface for:
/// - Setting the target user pool and username
/// - Configuring pagination options
/// - Building the final validated request
///
/// Example:
/// ```dart
/// final builder = AortemCognitoAdminListGroupsForUserBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..limit(10);
/// ```
class AortemCognitoAdminListGroupsForUserBuilder {
  String? _userPoolId;
  String? _username;
  int? _limit;
  String? _nextToken;

  /// Sets the User Pool ID for the group listing operation.
  ///
  /// Parameters:
  /// - [value]: The Cognito User Pool ID (format: region_id)
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminListGroupsForUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username whose groups should be listed.
  ///
  /// Parameters:
  /// - [value]: The username to query groups for
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminListGroupsForUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the maximum number of groups to return (0-60).
  ///
  /// Parameters:
  /// - [value]: The maximum number of results (AWS max is 60)
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminListGroupsForUserBuilder limit(int value) {
    _limit = value;
    return this;
  }

  /// Sets the pagination token for continuing a previous listing.
  ///
  /// Parameters:
  /// - [value]: Opaque token from a previous response
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminListGroupsForUserBuilder nextToken(String value) {
    _nextToken = value;
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// Parameters:
  /// - [region]: AWS region for the request
  /// - [httpClient]: HTTP client implementation
  /// - [maxRetries]: Maximum retry attempts (default 2)
  /// - [requestTimeout]: Timeout per request (default 20 seconds)
  ///
  /// Returns:
  /// - Configured [AortemCognitoAdminListGroupsForUserRequest]
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if required fields are missing
  AortemCognitoAdminListGroupsForUserRequest build({
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

    return AortemCognitoAdminListGroupsForUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      limit: _limit,
      nextToken: _nextToken,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer-style facade for AdminListGroupsForUser operation.
///
/// Provides a higher-level interface for building and executing group
/// listing requests using the builder pattern.
///
/// Example Usage:
/// ```dart
/// final consumer = AortemCognitoAdminListGroupsForUserConsumer(
///   region: 'us-west-2',
///   httpClient: client,
/// );
///
/// try {
///   final result = await consumer.run((b) => b
///     ..userPoolId('us-west-2_EXAMPLE')
///     ..username('testuser')
///     ..limit(10));
///
///   print('User belongs to ${result.groups.length} groups');
///   if (result.nextToken != null) {
///     print('More groups available with pagination token');
///   }
/// } catch (e) {
///   print('Error listing groups: $e');
/// }
/// ```
class AortemCognitoAdminListGroupsForUserConsumer {
  /// The AWS region for Cognito requests
  final String region;

  /// The HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new consumer instance.
  ///
  /// Parameters:
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout (default 20 seconds)
  AortemCognitoAdminListGroupsForUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to list user groups.
  ///
  /// Steps:
  /// 1. Invokes the [fn] callback to populate the builder
  /// 2. Validates and builds the request
  /// 3. Executes the request with retries
  ///
  /// Parameters:
  /// - [fn]: Callback that defines the request using the builder
  ///
  /// Returns:
  /// - [AortemCognitoAdminListGroupsForUserResult] containing groups and pagination token
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid parameters
  /// - [AortemCognitoServiceException] for API failures
  Future<AortemCognitoAdminListGroupsForUserResult> run(
    AortemCognitoAdminListGroupsForUserConsumerFn fn,
  ) async {
    final b = AortemCognitoAdminListGroupsForUserBuilder();
    fn(b);

    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // New AdminListGroupsForUser methods
  //
  // --------------------------------------------------------------------------------
  /// Lists the groups that a user belongs to in a Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListGroupsForUser` action.
  /// This operation retrieves a paginated list of groups associated with a user.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose groups are to be listed.
  /// @param limit Optional: The maximum number of results to be returned (0-60).
  /// @param nextToken Optional: An opaque pagination token for fetching the next page.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [AortemCognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminListGroupsForUserResult> adminListGroupsForUser({
    required String userPoolId,
    required String username,
    int? limit,
    String? nextToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminListGroupsForUserRequest(
      userPoolId: userPoolId,
      username: username,
      limit: limit,
      nextToken: nextToken,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Lists the groups a user belongs to using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [AortemCognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminListGroupsForUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.in.groups@example.com')
  ///      .limit(5),
  /// );
  /// ```
  Future<AortemCognitoAdminListGroupsForUserResult> adminListGroupsForUserWith({
    required AortemCognitoAdminListGroupsForUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminListGroupsForUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }
}
