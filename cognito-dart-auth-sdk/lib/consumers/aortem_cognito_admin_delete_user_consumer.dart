// aortem_cognito_admin_delete_user_consumer.dart
//
// Consumer/builder-style facade for AdminDeleteUser.
// Lets callers supply pool + username at runtime, then executes Ticket #9 request.

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_delete_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// A function type that configures an [AortemCognitoAdminDeleteUserBuilder].
///
/// Used to provide a fluent interface for building AdminDeleteUser requests.
typedef AortemCognitoDeleteUserConsumerFn =
    void Function(AortemCognitoAdminDeleteUserBuilder b);

/// A builder class for constructing AdminDeleteUser requests to Amazon Cognito.
///
/// Provides a fluent interface for configuring the request parameters before
/// building the actual request object. Validates required parameters when building.
///
/// Example:
/// ```dart
/// final result = await AortemCognitoAdminDeleteUserConsumer(...).run((b) {
///   b.userPoolId('us-east-1_abc123')
///    .username('johndoe');
/// });
/// ```
class AortemCognitoAdminDeleteUserBuilder {
  String? _userPoolId;
  String? _username;

  /// Sets the user pool ID where the user will be deleted.
  ///
  /// The value must match the pattern `[\w-]+_[0-9a-zA-Z]+`.
  /// The value will be trimmed of whitespace.
  AortemCognitoAdminDeleteUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username (or alias/sub) of the user to be deleted.
  ///
  /// The value will be trimmed of whitespace. Length must be between 1 and 128
  /// characters (enforced when building the request).
  AortemCognitoAdminDeleteUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Builds the underlying [AortemCognitoAdminDeleteUserRequest].
  ///
  /// Validates that required parameters (userPoolId and username) are set.
  /// Throws [AortemCognitoValidationException] if validation fails.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the user pool is located
  /// - [httpClient]: The HTTP client to use for making requests
  /// - [maxRetries]: Maximum number of retries for transient failures (default: 2)
  /// - [requestTimeout]: Timeout duration for the request (default: 20 seconds)
  AortemCognitoAdminDeleteUserRequest build({
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

    return AortemCognitoAdminDeleteUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// A high-level consumer for executing AdminDeleteUser operations.
///
/// Provides a convenient way to execute Cognito AdminDeleteUser operations
/// using a builder pattern for request configuration.
///
/// Handles request building, validation, execution, and retries automatically.
class AortemCognitoAdminDeleteUserConsumer {
  /// The AWS region where the user pool is located.
  final String region;

  /// The HTTP client to use for making requests.
  final AortemCognitoHttpClient httpClient;

  /// The maximum number of retries for failed requests.
  final int maxRetries;

  /// The timeout duration for the request.
  final Duration requestTimeout;

  /// Creates a new consumer with the given configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Request timeout duration (default: 20 seconds)
  AortemCognitoAdminDeleteUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the AdminDeleteUser operation with the given configuration.
  ///
  /// The flow is:
  /// 1. Caller populates builder via the [consumer] function
  /// 2. Builds the request (with validation)
  /// 3. Executes the request (with retries if configured)
  ///
  /// Returns a [Future] that completes with [AortemCognitoAdminDeleteUserResult]
  /// on success.
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if parameters are invalid
  /// - [AortemCognitoServiceException] if the request fails
  Future<AortemCognitoAdminDeleteUserResult> run(
    AortemCognitoDeleteUserConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminDeleteUserBuilder();
    consumer(b);

    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }
}
