import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_device_status_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Callback used to configure an AdminUpdateDeviceStatus builder.
typedef CognitoAdminUpdateDeviceStatusConsumerFn =
    void Function(CognitoAdminUpdateDeviceStatusBuilder b);

/// Fluent builder for AdminUpdateDeviceStatus requests.
class CognitoAdminUpdateDeviceStatusBuilder {
  String? _userPoolId;
  String? _username;
  String? _deviceKey;
  String? _deviceRememberedStatus;

  /// Sets the user pool ID.
  CognitoAdminUpdateDeviceStatusBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username.
  CognitoAdminUpdateDeviceStatusBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the device key.
  CognitoAdminUpdateDeviceStatusBuilder deviceKey(String value) {
    _deviceKey = value.trim();
    return this;
  }

  /// Marks the device as remembered.
  CognitoAdminUpdateDeviceStatusBuilder remembered() {
    _deviceRememberedStatus = 'remembered';
    return this;
  }

  /// Marks the device as not remembered.
  CognitoAdminUpdateDeviceStatusBuilder notRemembered() {
    _deviceRememberedStatus = 'not_remembered';
    return this;
  }

  /// Sets the raw Cognito remembered status.
  CognitoAdminUpdateDeviceStatusBuilder deviceRememberedStatus(String value) {
    _deviceRememberedStatus = value.trim();
    return this;
  }

  /// Builds a validated request.
  CognitoAdminUpdateDeviceStatusRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final userPoolId = _userPoolId ?? '';
    final username = _username ?? '';
    final deviceKey = _deviceKey ?? '';
    final status = _deviceRememberedStatus ?? '';

    if (userPoolId.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (username.isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (deviceKey.isEmpty) {
      throw CognitoValidationException('deviceKey is required.');
    }
    if (status.isEmpty) {
      throw CognitoValidationException('deviceRememberedStatus is required.');
    }

    return CognitoAdminUpdateDeviceStatusRequest(
      userPoolId: userPoolId,
      username: username,
      deviceKey: deviceKey,
      deviceRememberedStatus: status,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer facade for AdminUpdateDeviceStatus.
class CognitoAdminUpdateDeviceStatusConsumer {
  /// AWS region for Cognito requests.
  final String region;

  /// Configured Cognito HTTP client.
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts for transient failures.
  final int maxRetries;

  /// Per-request timeout.
  final Duration requestTimeout;

  /// Creates a consumer with shared request settings.
  CognitoAdminUpdateDeviceStatusConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Builds and executes an AdminUpdateDeviceStatus request.
  Future<CognitoAdminUpdateDeviceStatusResult> run(
    CognitoAdminUpdateDeviceStatusConsumerFn consumer,
  ) async {
    final builder = CognitoAdminUpdateDeviceStatusBuilder();
    consumer(builder);
    final request = builder.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await request.execute();
  }
}
