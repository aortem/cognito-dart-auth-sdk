//    cognito_admin_set_user_mfa_preference_request.dart

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Request class for setting user MFA preferences as an administrator.
///
/// This class handles the AdminSetUserMFAPreference API operation, which allows
/// administrators to set multi-factor authentication (MFA) preferences for
/// users in a Cognito User Pool. This can include enabling/disabling SMS MFA,
/// email MFA, or software token MFA (TOTP).
///
/// Example:
/// ```dart
/// final request =    CognitoAdminSetUserMFAPreferenceRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   softwareTokenMfaSettings: {
///     'Enabled': true,
///     'PreferredMfa': true,
///   },
///   region: 'us-west-2',
///   httpClient: httpClient,
/// );
///
/// final result = await request.execute();
/// ```
class CognitoAdminSetUserMFAPreferenceRequest {
  /// The ID of the user pool where the user exists.
  final String userPoolId;

  /// The username of the user whose MFA preferences are being set.
  final String username;

  /// Settings for email-based MFA.
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether email MFA is enabled
  /// - 'PreferredMfa': bool - Whether email MFA is the preferred method
  final Map<String, dynamic>? emailMfaSettings;

  /// Settings for SMS-based MFA.
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether SMS MFA is enabled
  /// - 'PreferredMfa': bool - Whether SMS MFA is the preferred method
  final Map<String, dynamic>? smsMfaSettings;

  /// Settings for software token MFA (TOTP).
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether software token MFA is enabled
  /// - 'PreferredMfa': bool - Whether software token MFA is the preferred method
  final Map<String, dynamic>? softwareTokenMfaSettings;

  /// AWS region where the User Pool is located (e.g., "us-west-2").
  final String region;

  /// SigV4-capable HTTP client for making authenticated requests to AWS.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout duration (default: 20 seconds).
  final Duration requestTimeout;

  /// Creates a new AdminSetUserMFAPreference request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [username]: Required - The username of the user
  /// - [emailMfaSettings]: Optional - Settings for email MFA
  /// - [smsMfaSettings]: Optional - Settings for SMS MFA
  /// - [softwareTokenMfaSettings]: Optional - Settings for software token MFA
  /// - [region]: Required - AWS region identifier
  /// - [httpClient]: Required - HTTP client for making requests
  /// - [maxRetries]: Optional - Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional - Request timeout (default: 20 seconds)
  ///
  /// Throws [CognitoValidationException] if required parameters are invalid.
  CognitoAdminSetUserMFAPreferenceRequest({
    required this.userPoolId,
    required this.username,
    this.emailMfaSettings,
    this.smsMfaSettings,
    this.softwareTokenMfaSettings,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    if (userPoolId.trim().isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
  }

  /// Executes the AdminSetUserMFAPreference API request.
  ///
  /// This method:
  /// 1. Validates the required parameters
  /// 2. Constructs the appropriate JSON payload
  /// 3. Signs and sends the request using SigV4 authentication
  /// 4. Handles the response and returns the result
  ///
  /// Returns:
  /// A Future that completes with [   CognitoAdminSetUserMFAPreferenceResult]
  /// on successful MFA preference update.
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for AWS service errors
  /// - Other exceptions for network failures or unexpected errors
  Future<CognitoAdminSetUserMFAPreferenceResult> execute() async {
    final payload = <String, dynamic>{
      'UserPoolId': userPoolId,
      'Username': username,
    };

    // Add optional MFA settings if provided
    if (emailMfaSettings != null) {
      payload['EmailMfaSettings'] = emailMfaSettings;
    }
    if (smsMfaSettings != null) {
      payload['SMSMfaSettings'] = smsMfaSettings;
    }
    if (softwareTokenMfaSettings != null) {
      payload['SoftwareTokenMfaSettings'] = softwareTokenMfaSettings;
    }

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final response = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminSetUserMFAPreference',
          region: region,
          payload: payload,
          timeout: requestTimeout,
        );

        if (response.statusCode == 200) {
          return CognitoAdminSetUserMFAPreferenceResult.fromJson(
            response.jsonBody ?? {},
          );
        }

        // Handle 4xx errors (client errors) - non-retryable
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw CognitoServiceException(
            'AdminSetUserMFAPreference failed. Body: ${response.bodyString}',
            statusCode: response.statusCode,
          );
        }

        // Handle 5xx errors (server errors) - potentially retryable
        if (response.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminSetUserMFAPreference temporary failure.',
            statusCode: response.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminSetUserMFAPreference unexpected status.',
          statusCode: response.statusCode,
        );
      } catch (e) {
        lastError = e;
        if (!_isTransient(e) || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw CognitoServiceException(
      'AdminSetUserMFAPreference failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying.
  ///
  /// Transient errors include network timeouts, socket exceptions, and
  /// server-side 5xx errors that might be resolved by retrying.
  ///
  /// Parameters:
  /// - [e]: The exception to check
  ///
  /// Returns:
  /// true if the error is transient and retryable, false otherwise
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}

/// Represents the successful result of an AdminSetUserMFAPreference operation.
///
/// This class provides access to the raw JSON response from the AWS Cognito
/// service, which typically contains minimal data as the operation primarily
/// returns an HTTP 200 status on success.
class CognitoAdminSetUserMFAPreferenceResult {
  /// The raw JSON response from the AWS Cognito service.
  final Map<String, dynamic> json;

  /// Creates a new result instance with the provided JSON data.
  ///
  /// Parameters:
  /// - [json]: The JSON response from the AWS Cognito service
  CognitoAdminSetUserMFAPreferenceResult(this.json);

  /// Creates a result instance from a JSON map.
  ///
  /// Parameters:
  /// - [json]: The JSON map to parse
  ///
  /// Returns:
  /// A new [   CognitoAdminSetUserMFAPreferenceResult] instance
  factory CognitoAdminSetUserMFAPreferenceResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return CognitoAdminSetUserMFAPreferenceResult(json);
  }
}
