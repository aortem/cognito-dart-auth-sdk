import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Request class for AdminSetUserPassword API operation.
///
/// This class handles the AdminSetUserPassword operation, which allows
/// administrators to set a user's password in an AWS Cognito User Pool.
/// This operation can set either a temporary or permanent password and
/// is useful for administrative password resets or initial user setup.
///
/// The AdminSetUserPassword API requires administrator credentials and
/// bypasses the typical password reset flow that requires user verification.
///
/// Example:
/// ```dart
/// final request =    CognitoAdminSetUserPasswordRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   password: 'TempPassword123!',
///   permanent: false, // Set as temporary password
///   region: 'us-west-2',
///   httpClient: httpClient,
/// );
///
/// final result = await request.execute();
/// ```
class CognitoAdminSetUserPasswordRequest {
  /// The ID of the user pool where the user exists.
  ///
  /// Must be a valid Cognito User Pool ID in the format: `region_randomId`
  final String userPoolId;

  /// The username of the user whose password is being set.
  ///
  /// This can be the user's actual username, email, or phone number,
  /// depending on how the user pool is configured.
  final String username;

  /// The new password to set for the user.
  ///
  /// Must comply with the password policy configured in the Cognito User Pool.
  /// Typically includes requirements for:
  /// - Minimum length (usually 8+ characters)
  /// - Uppercase letters
  /// - Lowercase letters
  /// - Numbers
  /// - Special characters
  final String password;

  /// Specifies whether the password is permanent or temporary.
  ///
  /// - If `true`: The password is permanent and the user won't be forced to change it
  /// - If `false`: The password is temporary and user must change it on next sign-in
  /// - If `null`: Uses the default behavior (typically treated as temporary)
  final bool? permanent;

  /// AWS region where the User Pool is located (e.g., "us-west-2").
  final String region;

  /// SigV4-capable HTTP client for making authenticated requests to AWS.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout duration (default: 20 seconds).
  final Duration requestTimeout;

  /// Creates a new AdminSetUserPassword request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [username]: Required - The username of the user
  /// - [password]: Required - The new password to set
  /// - [permanent]: Optional - Whether the password is permanent (default: null)
  /// - [region]: Required - AWS region identifier
  /// - [httpClient]: Required - HTTP client for making requests
  /// - [maxRetries]: Optional - Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional - Request timeout (default: 20 seconds)
  ///
  /// Throws [ArgumentError] if required parameters are missing or empty.
  CognitoAdminSetUserPasswordRequest({
    required this.userPoolId,
    required this.username,
    required this.password,
    this.permanent,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    if (userPoolId.trim().isEmpty) {
      throw ArgumentError('userPoolId is required');
    }
    if (username.trim().isEmpty) {
      throw ArgumentError('username is required');
    }
    if (password.trim().isEmpty) {
      throw ArgumentError('password is required');
    }
  }

  /// Executes the AdminSetUserPassword API request.
  ///
  /// This method:
  /// 1. Validates the required parameters
  /// 2. Constructs the appropriate JSON payload
  /// 3. Signs and sends the request using SigV4 authentication
  /// 4. Handles the response and returns the result
  ///
  /// The API target is `AWSCognitoIdentityProviderService.AdminSetUserPassword`
  /// and requires administrator privileges.
  ///
  /// Returns:
  /// A Future that completes with [   CognitoAdminSetUserPasswordResult]
  /// on successful password setting.
  ///
  /// Throws:
  /// - [ArgumentError] for invalid or missing parameters
  /// - [Exception] for HTTP errors, network failures, or AWS service errors
  /// - Various AWS Cognito-specific exceptions for authentication or authorization failures
  Future<CognitoAdminSetUserPasswordResult> execute() async {
    final Map<String, dynamic> payload = {
      'UserPoolId': userPoolId,
      'Username': username,
      'Password': password,
    };
    if (permanent != null) {
      payload['Permanent'] = permanent;
    }

    final resp = await httpClient.post(
      region: region,
      xAmzTarget: 'AWSCognitoIdentityProviderService.AdminSetUserPassword',
      payload: payload,
      timeout: requestTimeout,
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed with ${resp.statusCode}');
    }

    return CognitoAdminSetUserPasswordResult(
      success: true,
      rawResponse: resp.jsonBody ?? {},
    );
  }
}

/// Represents the successful result of an AdminSetUserPassword operation.
///
/// This class provides access to the raw response data from the AWS Cognito
/// service. The AdminSetUserPassword API typically returns an HTTP 200 status
/// with an empty or minimal response body on success.
class CognitoAdminSetUserPasswordResult {
  /// Indicates whether the password setting operation was successful.
  ///
  /// For successful AdminSetUserPassword operations, this should always be true.
  /// If the operation fails, an exception is thrown instead of returning a result.
  final bool success;

  /// The raw JSON response from the AWS Cognito service.
  ///
  /// Contains the complete response data, which may include additional
  /// metadata or confirmation details from the service. For this API,
  /// the response body is typically empty on success.
  final Map<String, dynamic> rawResponse;

  /// Creates a new result instance for AdminSetUserPassword operation.
  ///
  /// Parameters:
  /// - [success]: Required - Whether the operation was successful
  /// - [rawResponse]: Required - The raw JSON response from AWS Cognito
  CognitoAdminSetUserPasswordResult({
    required this.success,
    required this.rawResponse,
  });
}
