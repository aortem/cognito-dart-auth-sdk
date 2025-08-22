import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_password_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a function that configures an AdminSetUserPassword builder
/// using a fluent interface pattern.
///
/// This function type allows callers to provide password setting parameters
/// through method chaining while maintaining a clean, reusable interface.
typedef CognitoAdminSetUserPasswordFn =
    void Function(CognitoAdminSetUserPasswordBuilder b);

/// Builder class for constructing AdminSetUserPassword requests with
/// a fluent interface pattern.
///
/// This builder provides a method-chaining API to configure all parameters
/// required for setting a user's password as an administrator in AWS Cognito.
/// It supports setting both temporary and permanent passwords.
class CognitoAdminSetUserPasswordBuilder {
  String? _userPoolId;
  String? _username;
  String? _password;
  bool? _permanent;

  /// Sets the User Pool ID where the user exists.
  ///
  /// This is a required parameter that identifies the Cognito User Pool
  /// for the password setting operation.
  ///
  /// Example:
  /// ```dart
  /// builder.userPoolId('us-west-2_EXAMPLE');
  /// ```
  CognitoAdminSetUserPasswordBuilder userPoolId(String v) {
    _userPoolId = v;
    return this;
  }

  /// Sets the username of the user whose password is being set.
  ///
  /// This is a required parameter that specifies which user account
  /// to update the password for.
  ///
  /// Example:
  /// ```dart
  /// builder.username('testuser');
  /// ```
  CognitoAdminSetUserPasswordBuilder username(String v) {
    _username = v;
    return this;
  }

  /// Sets the new password for the user.
  ///
  /// This is a required parameter that specifies the new password value.
  /// The password must comply with the password policy configured in the
  /// Cognito User Pool (length, complexity, character requirements).
  ///
  /// Example:
  /// ```dart
  /// builder.password('TempPassword123!');
  /// ```
  CognitoAdminSetUserPasswordBuilder password(String v) {
    _password = v;
    return this;
  }

  /// Sets whether the password should be permanent or temporary.
  ///
  /// - `true`: The password is permanent and user won't be forced to change it
  /// - `false`: The password is temporary and user must change it on next sign-in
  /// - `null`: Uses default behavior (typically treated as temporary)
  ///
  /// Example:
  /// ```dart
  /// builder.permanent(false); // Set as temporary password
  /// ```
  CognitoAdminSetUserPasswordBuilder permanent(bool v) {
    _permanent = v;
    return this;
  }

  /// Constructs an AdminSetUserPassword request instance.
  ///
  /// Combines all configured parameters into a ready-to-execute request object.
  /// Note: Validation of required parameters is handled by the request class itself.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the User Pool is located
  /// - [httpClient]: The HTTP client to use for the request
  /// - [maxRetries]: Maximum number of retry attempts for the request
  /// - [requestTimeout]: Timeout duration for the HTTP request
  ///
  /// Returns:
  /// A configured [   CognitoAdminSetUserPasswordRequest] instance
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are missing (handled by request constructor)
  CognitoAdminSetUserPasswordRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return CognitoAdminSetUserPasswordRequest(
      userPoolId: _userPoolId ?? '',
      username: _username ?? '',
      password: _password ?? '',
      permanent: _permanent,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class that provides a reusable interface for executing
/// AdminSetUserPassword operations with shared configuration.
///
/// This class encapsulates the common configuration (region, HTTP client,
/// retry settings, timeout) and provides a clean API for executing
/// password setting operations with different parameters for each call.
class CognitoAdminSetUserPasswordConsumer {
  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client used for making requests to AWS Cognito
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for HTTP requests
  final Duration requestTimeout;

  /// Creates a new AdminSetUserPassword consumer with shared configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier (e.g., 'us-west-2')
  /// - [httpClient]: Required HTTP client instance for making requests
  /// - [maxRetries]: Optional maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional request timeout duration (default: 20 seconds)
  CognitoAdminSetUserPasswordConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminSetUserPassword request with builder-style configuration.
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
  ///   ..password('TempPassword123!')
  ///   ..permanent(false));
  /// ```
  ///
  /// Parameters:
  /// - [fn]: A function that receives and configures a builder instance
  ///
  /// Returns:
  /// A Future that completes with the result of the password setting operation
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are missing
  /// - Various network and AWS Cognito service exceptions
  Future<CognitoAdminSetUserPasswordResult> run(
    CognitoAdminSetUserPasswordFn fn,
  ) async {
    final b = CognitoAdminSetUserPasswordBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return req.execute();
  }
}
