// admin_forget_device_consumer.dart
/// Consumer/builder-style facade for AdminForgetDevice operation.
///
/// Provides a fluent interface for building requests to forget
/// a user's device in Amazon Cognito user pools.
library cognito_admin_forget_device_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef CognitoForgetDeviceConsumerFn =
    void Function(CognitoAdminForgetDeviceBuilder b);

/// Builder class for constructing AdminForgetDevice requests.
///
/// Provides a fluent interface for setting parameters with validation.
class CognitoAdminForgetDeviceBuilder {
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
  CognitoAdminForgetDeviceBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username associated with the device.
  ///
  /// @param value The username (1-128 characters)
  /// @return The builder instance for method chaining
  CognitoAdminForgetDeviceBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the device key to forget.
  ///
  /// @param value The unique device identifier
  /// @return The builder instance for method chaining
  CognitoAdminForgetDeviceBuilder deviceKey(String value) {
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
  /// @throws  CognitoValidationException if required fields are missing
  CognitoAdminForgetDeviceRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    final dk = _deviceKey?.trim() ?? '';

    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (dk.isEmpty) {
      throw CognitoValidationException('deviceKey is required.');
    }

    return CognitoAdminForgetDeviceRequest(
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
class CognitoAdminForgetDeviceConsumer {
  /// AWS region for the Cognito endpoint
  final String region;

  /// Configured HTTP client for AWS requests
  final CognitoHttpClient httpClient;

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
  CognitoAdminForgetDeviceConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the device forget flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result
  /// @throws  CognitoValidationException for invalid inputs
  /// @throws  CognitoServiceException for API failures
  Future<CognitoAdminForgetDeviceResult> run(
    CognitoForgetDeviceConsumerFn consumer,
  ) async {
    final b = CognitoAdminForgetDeviceBuilder();
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
