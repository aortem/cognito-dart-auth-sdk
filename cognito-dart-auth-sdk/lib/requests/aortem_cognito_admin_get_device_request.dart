/// AdminGetDevice — Retrieves details for a user's remembered device.
///
/// This request allows administrators to fetch detailed information
/// about a specific device associated with a user in a Cognito user pool.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminGetDevice.html

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Immutable model representing a Cognito device.
///
/// Contains all fields returned by the AdminGetDevice API response.
///
/// ## Device Attributes
/// Common attributes include:
/// - `device_name`: User-friendly name of the device
/// - `device_status`: Current status of the device
/// - `device_os`: Operating system of the device
/// - `device_model`: Model information of the device
class AortemCognitoDevice {
  /// Unique identifier for the device (e.g., "us-west-2_abc-123...")
  final String deviceKey;

  /// Creation timestamp in Unix epoch seconds
  final double? deviceCreateDate;

  /// Last modification timestamp in Unix epoch seconds
  final double? deviceLastModifiedDate;

  /// Last authentication timestamp in Unix epoch seconds
  final double? deviceLastAuthenticatedDate;

  /// Additional device attributes as name-value pairs
  final Map<String, String> attributes;

  /// Creates a new device instance
  const AortemCognitoDevice({
    required this.deviceKey,
    this.deviceCreateDate,
    this.deviceLastModifiedDate,
    this.deviceLastAuthenticatedDate,
    required this.attributes,
  });

  /// Parses device information from Cognito API response
  ///
  /// @param m Raw response map from Cognito API
  /// @return Parsed device instance
  /// @throws FormatException if required fields are missing
  factory AortemCognitoDevice.fromJson(Map<String, dynamic> m) {
    final attrsList =
        (m['DeviceAttributes'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    final attrs = <String, String>{};
    for (final a in attrsList) {
      final name = (a['Name'] ?? '').toString();
      final value = (a['Value'] ?? '').toString();
      if (name.isNotEmpty) attrs[name] = value;
    }

    return AortemCognitoDevice(
      deviceKey: (m['DeviceKey'] ?? '').toString(),
      deviceCreateDate: m['DeviceCreateDate'] is num
          ? (m['DeviceCreateDate'] as num).toDouble()
          : null,
      deviceLastModifiedDate: m['DeviceLastModifiedDate'] is num
          ? (m['DeviceLastModifiedDate'] as num).toDouble()
          : null,
      deviceLastAuthenticatedDate: m['DeviceLastAuthenticatedDate'] is num
          ? (m['DeviceLastAuthenticatedDate'] as num).toDouble()
          : null,
      attributes: attrs,
    );
  }
}

/// Result container for AdminGetDevice operations.
///
/// Wraps the device information returned by the API.
class AortemCognitoAdminGetDeviceResult {
  /// The device details returned by Cognito
  final AortemCognitoDevice device;

  /// Creates a new result instance
  const AortemCognitoAdminGetDeviceResult(this.device);

  /// Parses the result from an HTTP response
  ///
  /// @param res HTTP response from Cognito
  /// @return Parsed result instance
  /// @throws AortemCognitoServiceException if response is malformed
  factory AortemCognitoAdminGetDeviceResult.fromHttp(
    AortemCognitoHttpResponse res,
  ) {
    final json = res.jsonBody ?? const <String, dynamic>{};
    final dev = (json['Device'] as Map<String, dynamic>?);
    if (dev == null) {
      throw AortemCognitoServiceException(
        'AdminGetDevice response missing Device object.',
        statusCode: res.statusCode,
        responseBody: json,
      );
    }
    return AortemCognitoAdminGetDeviceResult(AortemCognitoDevice.fromJson(dev));
  }
}

/// {@template aortem_admin_get_device_request}
/// Request wrapper for the Cognito AdminGetDevice API.
///
/// Retrieves detailed information about a specific device associated with a user.
///
/// ### Usage
/// ```dart
/// final request = AortemCognitoAdminGetDeviceRequest(
///   userPoolId: 'us-east-1_abc123',
///   username: 'testuser',
///   deviceKey: 'device_123',
///   region: 'us-east-1',
///   httpClient: httpClient,
/// );
///
/// final result = await request.execute();
/// print('Device last used: ${result.device.deviceLastAuthenticatedDate}');
/// ```
///
/// ### Validation
/// - `userPoolId`: Must match `[\w-]+_[0-9a-zA-Z]+`
/// - `username`: 1-128 characters
/// - `deviceKey`: Must match `[\w-]+_[0-9a-f-]+` (max 55 chars)
///
/// ### Error Handling
/// - [AortemCognitoValidationException]: Invalid input parameters
/// - [AortemCognitoServiceException]: API failures or malformed responses
/// {@endtemplate}
class AortemCognitoAdminGetDeviceRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The username associated with the device
  final String username;

  /// The unique identifier of the device
  final String deviceKey;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for the request (default: 20 seconds)
  final Duration requestTimeout;

  /// {@macro aortem_admin_get_device_request}
  AortemCognitoAdminGetDeviceRequest({
    required this.userPoolId,
    required this.username,
    required this.deviceKey,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters
  ///
  /// @throws AortemCognitoValidationException if any parameters are invalid
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }

    if (username.trim().isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    if (username.length > 128) {
      throw AortemCognitoValidationException(
        'username must be <= 128 characters.',
      );
    }

    final deviceRe = RegExp(r'^[\w-]+_[0-9a-f-]+$');
    if (deviceKey.trim().isEmpty || !deviceRe.hasMatch(deviceKey)) {
      throw AortemCognitoValidationException(
        'deviceKey is required and must match [\\w-]+_[0-9a-f-]+.',
      );
    }
    if (deviceKey.length > 55) {
      throw AortemCognitoValidationException(
        'deviceKey must be <= 55 characters.',
      );
    }
  }

  /// Builds the request payload for the AWS API
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    'DeviceKey': deviceKey,
  };

  /// Executes the AdminGetDevice request
  ///
  /// @return Future resolving to AdminGetDeviceResult with device details
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminGetDeviceResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminGetDevice',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return AortemCognitoAdminGetDeviceResult.fromHttp(res);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminGetDevice failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminGetDevice temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminGetDevice unexpected status.',
          statusCode: res.statusCode,
        );
      } catch (e) {
        lastError = e;
        final transient = _isTransient(e);
        if (!transient || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw AortemCognitoServiceException(
      'AdminGetDevice failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
