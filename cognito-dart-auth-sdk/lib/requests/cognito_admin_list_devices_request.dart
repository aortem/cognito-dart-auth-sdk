// admin_list_devices_request.dart
//    cognito_admin_list_devices_request.dart
//
// AdminListDevices — Lists a user's registered devices in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminListDevices
//
// Depends on shared types:
// -    CognitoHttpClient
// -    CognitoValidationException
// -    CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart'
    show CognitoServiceException;
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents the result of a successful AdminListDevices request.
///
/// Contains the list of registered devices and an optional pagination token
/// for retrieving additional results.
class CognitoAdminListDevicesResult {
  /// The list of registered devices, each represented as a map of device attributes.
  ///
  /// Each device contains properties like:
  /// - DeviceKey: Unique identifier for the device
  /// - DeviceAttributes: List of name/value pairs
  /// - DeviceCreateDate: When the device was registered
  /// - DeviceLastModifiedDate: Last update timestamp
  /// - DeviceLastAuthenticatedDate: Last used timestamp
  final List<Map<String, dynamic>> devices;

  /// An opaque token for paginating through multiple pages of results.
  ///
  /// Will be null when there are no more pages available.
  final String? paginationToken;

  /// Constructure
  const CognitoAdminListDevicesResult({
    required this.devices,
    this.paginationToken,
  });

  /// Creates a result instance from the raw API response JSON.
  factory CognitoAdminListDevicesResult.fromJson(Map<String, dynamic> json) {
    final items = (json['Devices'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();

    final token = json['PaginationToken'] as String?;
    return CognitoAdminListDevicesResult(
      devices: items,
      paginationToken: token,
    );
  }
}

/// Request wrapper for AdminListDevices API operation.
///
/// This class handles listing the registered devices for a specific user
/// in a Cognito user pool, with support for pagination.
///
/// Example Usage:
/// ```dart
/// final req =    CognitoAdminListDevicesRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   region: 'us-west-2',
///   httpClient: client,
///   limit: 10,
/// );
///
/// try {
///   final res = await req.execute();
///   print('Found ${res.devices.length} devices');
///   if (res.paginationToken != null) {
///     print('More devices available with pagination token');
///   }
/// } on    CognitoValidationException catch (e) {
///   print('Validation error: ${e.message}');
/// } on    CognitoServiceException catch (e) {
///   print('Service error (${e.statusCode}): ${e.message}');
/// }
/// ```
class CognitoAdminListDevicesRequest {
  /// The ID of the user pool containing the user
  final String userPoolId;

  /// The username whose devices should be listed
  final String username;

  /// Maximum number of devices to return (0-60, AWS max is 60)
  final int? limit;

  /// Token for paginating through multiple pages of results
  final String? paginationToken;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new AdminListDevices request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required Cognito User Pool ID
  /// - [username]: Required username to list devices for
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [limit]: Optional maximum number of devices to return (0-60)
  /// - [paginationToken]: Optional token for paginated results
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout per request (default 20 seconds)
  CognitoAdminListDevicesRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.limit,
    this.paginationToken,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters against AWS constraints.
  ///
  /// Throws:
  /// - [CognitoValidationException] if any parameters are invalid
  void _validate() {
    // Pool ID: [\w-]+_[0-9a-zA-Z]+
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (limit != null) {
      if (limit! < 0 || limit! > 60) {
        throw CognitoValidationException('limit must be between 0 and 60.');
      }
    }
    if (paginationToken != null) {
      if (paginationToken!.isEmpty ||
          RegExp(r'^\s+$').hasMatch(paginationToken!)) {
        throw CognitoValidationException(
          'paginationToken must be a non-empty, non-whitespace string.',
        );
      }
    }
  }

  /// Builds the API request payload.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
    if (limit != null) 'Limit': limit,
    if (paginationToken != null) 'PaginationToken': paginationToken,
  };

  /// Executes the AdminListDevices request.
  ///
  /// Handles:
  /// - Automatic retries for transient failures
  /// - Error response conversion
  /// - Response parsing
  ///
  /// Returns:
  /// - [   CognitoAdminListDevicesResult] containing devices and pagination token
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for API failures
  Future<CognitoAdminListDevicesResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminListDevices',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          final body = res.jsonBody ?? const <String, dynamic>{};
          return CognitoAdminListDevicesResult.fromJson(body);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminListDevices failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminListDevices temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminListDevices unexpected status.',
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

    throw CognitoServiceException(
      'AdminListDevices failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying.
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
