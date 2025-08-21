// admin_enable_user_consumer.dart
/// Consumer/builder-style facade for AdminEnableUser operation.
///
/// Provides a fluent interface for building requests to re-enable users
/// in Amazon Cognito user pools.
library cognito_admin_enable_user_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_enable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef AortemCognitoEnableUserConsumerFn =
    void Function(AortemCognitoAdminEnableUserBuilder b);

/// Builder class for constructing AdminEnableUser requests.
///
/// Provides a fluent interface for setting parameters with validation.
class AortemCognitoAdminEnableUserBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the username to re-enable
  String? _username;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminEnableUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username to re-enable.
  ///
  /// @param value The username to re-enable (1-128 characters)
  /// @return The builder instance for method chaining
  AortemCognitoAdminEnableUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminEnableUser request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminEnableUserRequest build({
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

    return AortemCognitoAdminEnableUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminEnableUser operations.
///
/// Provides a simplified interface for executing user enable requests
/// using the builder pattern.
class AortemCognitoAdminEnableUserConsumer {
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
  AortemCognitoAdminEnableUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the user enable flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminEnableUserResult> run(
    AortemCognitoEnableUserConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminEnableUserBuilder();
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
