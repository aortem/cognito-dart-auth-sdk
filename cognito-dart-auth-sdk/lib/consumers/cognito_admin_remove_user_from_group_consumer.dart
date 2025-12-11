// admin_remove_user_from_group_consumer.dart
// admin_remove_user_from_group_consumer.dart
//    cognito_admin_remove_user_from_group_consumer.dart
//
// Consumer (builder) for AdminRemoveUserFromGroup.
// Lets callers provide parameters via a closure while reusing region/client.
//
// Example:
// final consumer =    CognitoAdminRemoveUserFromGroupConsumer(
//   region: 'us-west-2',
//   httpClient: client,
// );
// await consumer.run((b) => b
//   ..userPoolId('us-west-2_EXAMPLE')
//   ..username('testuser')
//   ..groupName('MyExampleGroup1'),
// );

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_remove_user_from_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a builder function that configures an AdminRemoveUserFromGroup request.
///
/// This function type allows callers to configure the user pool ID, username,
/// and group name using a fluent builder pattern.
typedef CognitoAdminRemoveUserFromGroupFn =
    void Function(CognitoAdminRemoveUserFromGroupBuilder b);

/// Builder class for constructing AdminRemoveUserFromGroup requests.
///
/// Provides a fluent interface for setting required parameters (userPoolId,
/// username, groupName) and building a configured request instance.
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminRemoveUserFromGroupBuilder();
/// builder
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..groupName('MyExampleGroup1');
/// ```
class CognitoAdminRemoveUserFromGroupBuilder {
  String? _userPoolId;
  String? _username;
  String? _groupName;

  /// Sets the user pool ID for the remove user from group operation.
  ///
  /// [v] - The Cognito user pool identifier (e.g., 'us-west-2_EXAMPLE')
  /// Returns the builder instance for method chaining.
  CognitoAdminRemoveUserFromGroupBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the username for the remove user from group operation.
  ///
  /// [v] - The username of the user to remove from the group
  /// Returns the builder instance for method chaining.
  CognitoAdminRemoveUserFromGroupBuilder username(String v) {
    _username = v.trim();
    return this;
  }

  /// Sets the group name for the remove user from group operation.
  ///
  /// [v] - The name of the group to remove the user from
  /// Returns the builder instance for method chaining.
  CognitoAdminRemoveUserFromGroupBuilder groupName(String v) {
    _groupName = v.trim();
    return this;
  }

  /// Builds a configured AdminRemoveUserFromGroup request.
  ///
  /// Validates that all required parameters (userPoolId, username, groupName)
  /// are provided and returns a ready-to-use request instance.
  ///
  /// [region] - AWS region where the user pool is located
  /// [httpClient] - HTTP client for making requests to AWS Cognito
  /// [maxRetries] - Maximum number of retry attempts for failed requests
  /// [requestTimeout] - Timeout duration for the request
  ///
  /// Throws [CognitoValidationException] if required parameters are missing.
  CognitoAdminRemoveUserFromGroupRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    final gn = _groupName?.trim() ?? '';

    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (gn.isEmpty) {
      throw CognitoValidationException('groupName is required.');
    }

    return CognitoAdminRemoveUserFromGroupRequest(
      userPoolId: up,
      username: un,
      groupName: gn,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class for executing AdminRemoveUserFromGroup operations.
///
/// Provides a convenient way to remove users from Cognito groups with
/// reusable configuration (region, HTTP client, retry settings).
///
/// This class encapsulates the request construction and execution logic,
/// allowing callers to focus on parameter configuration.
class CognitoAdminRemoveUserFromGroupConsumer {
  /// AWS region where the Cognito user pool is located.
  final String region;

  /// HTTP client used for making requests to AWS Cognito service.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests.
  final int maxRetries;

  /// Timeout duration for the HTTP request.
  final Duration requestTimeout;

  /// Creates a new consumer with the specified configuration.
  ///
  /// [region] - AWS region identifier (e.g., 'us-west-2')
  /// [httpClient] - Configured HTTP client for AWS requests
  /// [maxRetries] - Maximum retry attempts (default: 2)
  /// [requestTimeout] - Request timeout duration (default: 20 seconds)
  CognitoAdminRemoveUserFromGroupConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the AdminRemoveUserFromGroup operation.
  ///
  /// Configures the request using the provided builder function and
  /// executes it with the consumer's predefined settings.
  ///
  /// [fn] - Builder function that configures userPoolId, username, and groupName
  ///
  /// Returns a [Future] that completes with the operation result on success,
  /// or throws an exception on failure.
  Future<CognitoAdminRemoveUserFromGroupResult> run(
    CognitoAdminRemoveUserFromGroupFn fn,
  ) async {
    final b = CognitoAdminRemoveUserFromGroupBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.execute();
  }
}
