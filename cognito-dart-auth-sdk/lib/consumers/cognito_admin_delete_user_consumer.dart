// cognito_admin_delete_user_consumer.dart
//
// Consumer/builder-style facade for AdminDeleteUser.
// Lets callers supply pool + username at runtime, then executes Ticket #9 request.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// A function type that configures an [CognitoAdminDeleteUserBuilder].
///
/// Used to provide a fluent interface for building AdminDeleteUser requests.
typedef CognitoDeleteUserConsumerFn =
    void Function(CognitoAdminDeleteUserBuilder b);

/// A builder class for constructing AdminDeleteUser requests to Amazon Cognito.
///
/// Provides a fluent interface for configuring the request parameters before
/// building the actual request object. Validates required parameters when building.
///
/// Example:
/// ```dart
/// final result = await     (...).run((b) {
///   b.userPoolId('us-east-1_abc123')
///    .username('johndoe');
/// });
/// ```
class CognitoAdminDeleteUserBuilder {
  String? _userPoolId;
  String? _username;

  /// Sets the user pool ID where the user will be deleted.
  ///
  /// The value must match the pattern `[\w-]+_[0-9a-zA-Z]+`.
  /// The value will be trimmed of whitespace.
  CognitoAdminDeleteUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username (or alias/sub) of the user to be deleted.
  ///
  /// The value will be trimmed of whitespace. Length must be between 1 and 128
  /// characters (enforced when building the request).
  CognitoAdminDeleteUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Builds the underlying [CognitoAdminDeleteUserRequest].
  ///
  /// Validates that required parameters (userPoolId and username) are set.
  /// Throws [CognitoValidationException] if validation fails.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the user pool is located
  /// - [httpClient]: The HTTP client to use for making requests
  /// - [maxRetries]: Maximum number of retries for transient failures (default: 2)
  /// - [requestTimeout]: Timeout duration for the request (default: 20 seconds)
  CognitoAdminDeleteUserRequest build({
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

    return CognitoAdminDeleteUserRequest(
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
class CognitoAdminDeleteUserConsumer {
  /// The AWS region where the user pool is located.
  final String region;

  /// The HTTP client to use for making requests.
  final CognitoHttpClient httpClient;

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
  CognitoAdminDeleteUserConsumer({
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
  /// Returns a [Future] that completes with [CognitoAdminDeleteUserResult]
  /// on success.
  ///
  /// Throws:
  /// - [CognitoValidationException] if parameters are invalid
  /// - [ CognitoServiceException] if the request fails
  Future<CognitoAdminDeleteUserResult> run(
    CognitoDeleteUserConsumerFn consumer,
  ) async {
    final b = CognitoAdminDeleteUserBuilder();
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
