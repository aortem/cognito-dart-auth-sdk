// admin_get_user_consumer.dart
/// Consumer/builder-style facade for AdminGetDevice operation.
///
/// Provides a fluent interface for building requests to retrieve
/// device information from Amazon Cognito user pools.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminGetDevice.html

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Function type for builder configuration callbacks.
///
/// Used to configure the builder parameters before request execution.
typedef CognitoGetDeviceConsumerFn =
    void Function(CognitoAdminGetDeviceBuilder b);

/// Builder class for constructing AdminGetDevice requests.
///
/// Provides a fluent interface for setting parameters with validation.
///
/// ## Example Usage
/// ```dart
/// final result = await consumer.run((b) => b
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..deviceKey('us-west-2_abc-123'));
/// print('Device last used: ${result.device.deviceLastAuthenticatedDate}');
/// ```
class CognitoAdminGetDeviceBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the username associated with the device
  String? _username;

  /// Stores the device key to query
  String? _deviceKey;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  CognitoAdminGetDeviceBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username associated with the device.
  ///
  /// @param value The username (1-128 characters)
  /// @return The builder instance for method chaining
  CognitoAdminGetDeviceBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the device key to query.
  ///
  /// @param value The unique device identifier (format: [\w-]+_[0-9a-f-]+)
  /// @return The builder instance for method chaining
  CognitoAdminGetDeviceBuilder deviceKey(String value) {
    _deviceKey = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminGetDevice request
  /// @throws    CognitoValidationException if required fields are missing
  CognitoAdminGetDeviceRequest build({
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

    return CognitoAdminGetDeviceRequest(
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

/// High-level consumer for AdminGetDevice operations.
///
/// Provides a simplified interface for executing device information requests
/// using the builder pattern.
class CognitoAdminGetDeviceConsumer {
  /// AWS region for the Cognito endpoint (e.g., 'us-west-2')
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
  CognitoAdminGetDeviceConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the device information retrieval flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result containing device details
  /// @throws    CognitoValidationException for invalid inputs
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminGetDeviceResult> run(
    CognitoGetDeviceConsumerFn consumer,
  ) async {
    final b = CognitoAdminGetDeviceBuilder();
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
