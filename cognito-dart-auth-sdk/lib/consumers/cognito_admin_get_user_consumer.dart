/// Consumer/builder-style facade for AdminGetUser operation.
///
/// Provides a fluent interface for building requests to retrieve
/// user information from Amazon Cognito user pools.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminGetUser.html

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for builder configuration callbacks.
///
/// Used to configure the builder parameters before request execution.
typedef AortemCognitoGetUserConsumerFn =
    void Function(AortemCognitoAdminGetUserBuilder b);

/// Builder class for constructing AdminGetUser requests.
///
/// Provides a fluent interface for setting parameters with validation.
///
/// ## Example Usage
/// ```dart
/// final result = await consumer.run((b) => b
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser'));
/// print('User email: ${result.user.attributes['email']}');
/// print('Account status: ${result.user.userStatus}');
/// ```
class AortemCognitoAdminGetUserBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the username to query
  String? _username;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminGetUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username to query.
  ///
  /// @param value The username (1-128 characters)
  /// @return The builder instance for method chaining
  AortemCognitoAdminGetUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminGetUser request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminGetUserRequest build({
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

    return AortemCognitoAdminGetUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminGetUser operations.
///
/// Provides a simplified interface for executing user information requests
/// using the builder pattern.
class AortemCognitoAdminGetUserConsumer {
  /// AWS region for the Cognito endpoint (e.g., 'us-west-2')
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for requests (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new consumer instance.
  ///
  /// @param region AWS region for Cognito endpoint
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  AortemCognitoAdminGetUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the user information retrieval flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result containing user details
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminGetUserResult> run(
    AortemCognitoGetUserConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminGetUserBuilder();
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
