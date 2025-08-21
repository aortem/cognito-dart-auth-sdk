/// Consumer/builder-style facade for AdminDisableUser operation.
///
/// Provides a fluent interface for building requests to disable users
/// in Amazon Cognito user pools.
library cognito_admin_disable_user_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_disable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef AortemCognitoDisableUserConsumerFn =
    void Function(AortemCognitoAdminDisableUserBuilder b);

/// Builder class for constructing AdminDisableUser requests.
///
/// Provides a fluent interface for setting parameters with validation.
class AortemCognitoAdminDisableUserBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the username to disable
  String? _username;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username to disable.
  ///
  /// @param value The username to disable (1-128 characters)
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminDisableUser request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminDisableUserRequest build({
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

    return AortemCognitoAdminDisableUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminDisableUser operations.
///
/// Provides a simplified interface for executing user disable requests
/// using the builder pattern.
class AortemCognitoAdminDisableUserConsumer {
  /// AWS region for the Cognito endpoint
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
  AortemCognitoAdminDisableUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the user disable flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminDisableUserResult> run(
    AortemCognitoDisableUserConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminDisableUserBuilder();
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
