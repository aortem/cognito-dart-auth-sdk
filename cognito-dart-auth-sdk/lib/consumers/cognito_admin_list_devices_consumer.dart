// admin_list_devices_consumer.dart
//    cognito_admin_list_devices_consumer.dart
//
// Consumer/builder-style facade for AdminListDevices operation.
// Provides a fluent interface for listing a user's registered devices
// in a Cognito user pool using admin privileges.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_devices_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Functional interface for configuring AdminListDevices requests via builder.
///
/// Used with [   CognitoAdminListDevicesConsumer.run] to dynamically
/// build device listing requests before sending them to Cognito.
typedef CognitoAdminListDevicesConsumerFn =
    void Function(CognitoAdminListDevicesBuilder b);

/// Fluent builder for constructing AdminListDevices requests.
///
/// Provides a chainable interface for:
/// - Setting the target user pool and username
/// - Configuring pagination options
/// - Building the final validated request
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminListDevicesBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..limit(10);
/// ```
class CognitoAdminListDevicesBuilder {
  String? _userPoolId;
  String? _username;
  int? _limit;
  String? _paginationToken;

  /// Sets the User Pool ID for the device listing operation.
  ///
  /// Parameters:
  /// - [value]: The Cognito User Pool ID (format: region_id)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminListDevicesBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username whose devices should be listed.
  ///
  /// Parameters:
  /// - [value]: The username to query devices for
  ///
  /// Returns the builder for method chaining.
  CognitoAdminListDevicesBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Sets the maximum number of devices to return (0-60).
  ///
  /// Parameters:
  /// - [value]: The maximum number of results (AWS max is 60)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminListDevicesBuilder limit(int value) {
    _limit = value;
    return this;
  }

  /// Sets the pagination token for continuing a previous listing.
  ///
  /// Parameters:
  /// - [value]: Opaque token from a previous response
  ///
  /// Returns the builder for method chaining.
  CognitoAdminListDevicesBuilder paginationToken(String value) {
    _paginationToken = value;
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// Parameters:
  /// - [region]: AWS region for the request
  /// - [httpClient]: HTTP client implementation
  /// - [maxRetries]: Maximum retry attempts (default 2)
  /// - [requestTimeout]: Timeout per request (default 20 seconds)
  ///
  /// Returns:
  /// - Configured [   CognitoAdminListDevicesRequest]
  ///
  /// Throws:
  /// - [CognitoValidationException] if required fields are missing
  CognitoAdminListDevicesRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw CognitoValidationException('username is required.');
    }

    return CognitoAdminListDevicesRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      limit: _limit,
      paginationToken: _paginationToken,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer-style facade for AdminListDevices operation.
///
/// Provides a higher-level interface for building and executing device
/// listing requests using the builder pattern.
class CognitoAdminListDevicesConsumer {
  /// The AWS region for Cognito requests
  final String region;

  /// The HTTP client for making requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new consumer instance.
  ///
  /// Parameters:
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout (default 20 seconds)
  CognitoAdminListDevicesConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to list user devices.
  ///
  /// Steps:
  /// 1. Invokes the [fn] callback to populate the builder
  /// 2. Validates and builds the request
  /// 3. Executes the request with retries
  ///
  /// Parameters:
  /// - [fn]: Callback that defines the request using the builder
  ///
  /// Returns:
  /// - [   CognitoAdminListDevicesResult] containing devices and pagination token
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [   CognitoServiceException] for API failures
  Future<CognitoAdminListDevicesResult> run(
    CognitoAdminListDevicesConsumerFn fn,
  ) async {
    final b = CognitoAdminListDevicesBuilder();
    fn(b);

    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }
}
