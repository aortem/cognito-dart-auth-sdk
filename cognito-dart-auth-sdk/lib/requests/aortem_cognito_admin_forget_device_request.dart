// admin_forget_device_request.dart
/// AdminForgetDevice — Deletes a remembered device for a user.
///
/// This request allows administrators to remove a specific device
/// from a user's remembered devices in a Cognito user pool.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminForgetDevice.html
library aortem_cognito_admin_forget_device_request;

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Result container for successful AdminForgetDevice operations.
///
/// The AWS API returns an empty response on success, so this serves
/// as a type-safe marker for completion.
class AortemCognitoAdminForgetDeviceResult {
  /// Creates a new successful result instance
  const AortemCognitoAdminForgetDeviceResult();
}

/// Request class for AdminForgetDevice API operation.
///
/// This removes a specific device from a user's remembered devices,
/// requiring them to re-authenticate on that device.
class AortemCognitoAdminForgetDeviceRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The username associated with the device
  final String username;

  /// The unique identifier of the device to forget
  final String deviceKey;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for the request
  final Duration requestTimeout;

  /// Creates a new AdminForgetDevice request
  ///
  /// @param userPoolId Required user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @param username Required username (1-128 characters)
  /// @param deviceKey Required device key (format: [\w-]+_[0-9a-f-]+)
  /// @param region AWS region for the user pool
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  AortemCognitoAdminForgetDeviceRequest({
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
    // Pattern: [\w-]+_[0-9a-zA-Z]+
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

    // DeviceKey pattern: [\w-]+_[0-9a-f-]+ (from AWS documentation)
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

  /// Executes the AdminForgetDevice request
  ///
  /// @return Future resolving to AdminForgetDeviceResult on success
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminForgetDeviceResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminForgetDevice',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const AortemCognitoAdminForgetDeviceResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminForgetDevice failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminForgetDevice temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminForgetDevice unexpected status.',
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
      'AdminForgetDevice failed after retries. Last error: $lastError',
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
