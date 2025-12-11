// admin_reset_user_password_consumer.dart
//    cognito_admin_reset_user_password_consumer.dart
//
// Consumer (builder) for AdminResetUserPassword.
// Lets callers provide parameters via a closure while reusing region/client.
//
// Example:
// final consumer =    CognitoAdminResetUserPasswordConsumer(
//   region: 'us-west-2',
//   httpClient: client,
// );
// await consumer.run((b) => b
//   ..userPoolId('us-west-2_EXAMPLE')
//   ..username('testuser')
//   ..clientMetadata({'MyTestKey': 'MyTestValue'}));

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_reset_user_password_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a function that configures an AdminResetUserPassword builder
/// using a fluent interface.
typedef CognitoAdminResetUserPasswordFn =
    void Function(CognitoAdminResetUserPasswordBuilder b);

/// Builder class for constructing AdminResetUserPassword requests with
/// a fluent interface pattern.
///
/// This builder allows for method chaining to configure all required
/// and optional parameters for an admin-initiated user password reset request.
class CognitoAdminResetUserPasswordBuilder {
  String? _userPoolId;
  String? _username;
  Map<String, String>? _clientMetadata;

  /// Sets the User Pool ID where the user account exists.
  ///
  /// This is a required parameter that identifies the Cognito User Pool
  /// from which to reset the user's password.
  ///
  /// Example:
  /// ```dart
  /// builder.userPoolId('us-west-2_EXAMPLE');
  /// ```
  CognitoAdminResetUserPasswordBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the username of the user whose password should be reset.
  ///
  /// This is a required parameter that specifies which user account
  /// to perform the password reset operation on.
  ///
  /// Example:
  /// ```dart
  /// builder.username('testuser');
  /// ```
  CognitoAdminResetUserPasswordBuilder username(String v) {
    _username = v.trim();
    return this;
  }

  /// Sets optional client metadata to be passed to the password reset process.
  ///
  /// This metadata can be used to provide additional context or parameters
  /// that might be needed by custom Lambda triggers during the password
  /// reset flow.
  ///
  /// Example:
  /// ```dart
  /// builder.clientMetadata({'MyTestKey': 'MyTestValue'});
  /// ```
  CognitoAdminResetUserPasswordBuilder clientMetadata(Map<String, String> v) {
    _clientMetadata = v;
    return this;
  }

  /// Constructs and validates an AdminResetUserPassword request instance.
  ///
  /// Validates that all required parameters are provided and constructs
  /// a ready-to-execute request object with the provided configuration.
  ///
  /// Throws [CognitoValidationException] if required parameters
  /// are missing or invalid.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the User Pool is located
  /// - [httpClient]: The HTTP client to use for the request
  /// - [maxRetries]: Maximum number of retry attempts for the request
  /// - [requestTimeout]: Timeout duration for the HTTP request
  CognitoAdminResetUserPasswordRequest build({
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

    return CognitoAdminResetUserPasswordRequest(
      userPoolId: up,
      username: un,
      clientMetadata: _clientMetadata,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class that provides a reusable interface for executing
/// AdminResetUserPassword operations with shared configuration.
///
/// This class encapsulates the common configuration (region, HTTP client,
/// retry settings, timeout) and provides a clean API for executing
/// password reset operations with different parameters for each call.
class CognitoAdminResetUserPasswordConsumer {
  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client used for making requests to AWS Cognito
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for HTTP requests
  final Duration requestTimeout;

  /// Creates a new AdminResetUserPassword consumer with shared configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier (e.g., 'us-west-2')
  /// - [httpClient]: Required HTTP client instance for making requests
  /// - [maxRetries]: Optional maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional request timeout duration (default: 20 seconds)
  CognitoAdminResetUserPasswordConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminResetUserPassword request with builder-style configuration.
  ///
  /// This method allows callers to provide request parameters through a
  /// fluent builder interface while reusing the consumer's shared configuration
  /// (region, HTTP client, retry settings, timeout).
  ///
  /// Example:
  /// ```dart
  /// final result = await consumer.run((b) => b
  ///   ..userPoolId('us-west-2_EXAMPLE')
  ///   ..username('testuser')
  ///   ..clientMetadata({'source': 'mobile-app'}));
  /// ```
  ///
  /// Parameters:
  /// - [fn]: A function that receives and configures a builder instance
  ///
  /// Returns:
  /// A Future that completes with the result of the password reset operation
  ///
  /// Throws:
  /// - [CognitoValidationException] if required parameters are missing
  /// - Various network and AWS Cognito service exceptions
  Future<CognitoAdminResetUserPasswordResult> run(
    CognitoAdminResetUserPasswordFn fn,
  ) async {
    final b = CognitoAdminResetUserPasswordBuilder();
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
