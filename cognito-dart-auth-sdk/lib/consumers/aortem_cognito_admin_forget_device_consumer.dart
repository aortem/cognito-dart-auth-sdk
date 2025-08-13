// admin_forget_device_consumer.dart
/// Consumer/builder-style facade for AdminForgetDevice operation.
///
/// Provides a fluent interface for building requests to forget
/// a user's device in Amazon Cognito user pools.
library aortem_cognito_admin_forget_device_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef AortemCognitoForgetDeviceConsumerFn =
    void Function(AortemCognitoAdminForgetDeviceBuilder b);

/// Builder class for constructing AdminForgetDevice requests.
///
/// Provides a fluent interface for setting parameters with validation.
class AortemCognitoAdminForgetDeviceBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the username associated with the device
  String? _username;

  /// Stores the device key to forget
  String? _deviceKey;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminForgetDeviceBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username associated with the device.
  ///
  /// @param value The username (1-128 characters)
  /// @return The builder instance for method chaining
  AortemCognitoAdminForgetDeviceBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the device key to forget.
  ///
  /// @param value The unique device identifier
  /// @return The builder instance for method chaining
  AortemCognitoAdminForgetDeviceBuilder deviceKey(String value) {
    _deviceKey = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminForgetDevice request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminForgetDeviceRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    final dk = _deviceKey?.trim() ?? '';

    if (up.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    if (dk.isEmpty) {
      throw AortemCognitoValidationException('deviceKey is required.');
    }

    return AortemCognitoAdminForgetDeviceRequest(
      userPoolId: up,
      username: un,
      deviceKey: dk,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminForgetDevice operations.
///
/// Provides a simplified interface for executing device forget requests
/// using the builder pattern.
class AortemCognitoAdminForgetDeviceConsumer {
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
  AortemCognitoAdminForgetDeviceConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the device forget flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminForgetDeviceResult> run(
    AortemCognitoForgetDeviceConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminForgetDeviceBuilder();
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
