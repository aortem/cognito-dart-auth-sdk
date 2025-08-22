// admin_respond_to_auth_challenge_request.dart
//    cognito_admin_respond_to_auth_challenge_request.dart
//
// AdminRespondToAuthChallenge — Answer a Cognito challenge (MFA/SRP/custom/etc.).
// AWS Target: AWSCognitoIdentityProviderService.AdminRespondToAuthChallenge
//
// Success: HTTP 200 with AuthenticationResult or next Challenge.
// Retries: transient (network/timeout/5xx) with small incremental backoff.
// Errors: 4xx =>    CognitoServiceException (non-retryable).
//
// Depends on shared types:
// -    CognitoHttpClient (send(...))
// -    CognitoValidationException
// -    CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents the result of an AdminRespondToAuthChallenge operation.
///
/// This class provides access to the raw response body and status code,
/// allowing callers to parse the authentication result or challenge parameters
/// as needed. The response may contain tokens, the next challenge, or other
/// authentication state information.
///
/// The response body typically contains either:
/// - AuthenticationResult (with access, id, and refresh tokens)
/// - ChallengeName and ChallengeParameters for the next authentication step
class CognitoAdminRespondToAuthChallengeResult {
  /// Raw JSON response body for callers to parse AuthenticationResult
  /// or ChallengeParameters as needed.
  final String body;

  /// HTTP status code of the response.
  final int statusCode;

  /// Creates a new challenge response result.
  ///
  /// Parameters:
  /// - [body]: The raw response body from the AWS Cognito service
  /// - [statusCode]: The HTTP status code of the response
  const CognitoAdminRespondToAuthChallengeResult({
    required this.body,
    required this.statusCode,
  });
}

/// Request wrapper for AdminRespondToAuthChallenge API operation.
///
/// This class handles responding to various authentication challenges in the
/// AWS Cognito authentication flow when initiated by an administrator.
/// Supported challenge types include:
/// - MFA challenges (SOFTWARE_TOKEN_MFA, SMS_MFA)
/// - Password challenges (PASSWORD_VERIFIER, NEW_PASSWORD_REQUIRED)
/// - Custom authentication challenges
/// - SRP authentication challenges
///
/// Example:
/// ```dart
/// final request =    CognitoAdminRespondToAuthChallengeRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   clientId: 'abc123clientid',
///   challengeName: 'SOFTWARE_TOKEN_MFA',
///   challengeResponses: {
///     'USERNAME': 'testuser',
///     'SOFTWARE_TOKEN_MFA_CODE': '123456',
///   },
///   region: 'us-west-2',
///   httpClient: httpClient,
///   session: previousSessionToken,
/// );
///
/// final result = await request.execute();
/// ```
class CognitoAdminRespondToAuthChallengeRequest {
  /// The user pool ID where the authentication challenge is being processed.
  final String userPoolId;

  /// The app client ID associated with the authentication request.
  final String clientId;

  /// The challenge name indicating the type of challenge being responded to.
  ///
  /// Common values include:
  /// - 'SOFTWARE_TOKEN_MFA': Time-based one-time password from authenticator app
  /// - 'SMS_MFA': SMS-based one-time password
  /// - 'NEW_PASSWORD_REQUIRED': Force change of temporary password
  /// - 'PASSWORD_VERIFIER': SRP authentication verification
  /// - 'CUSTOM_CHALLENGE': Custom authentication challenge
  final String challengeName;

  /// Challenge response key/value pairs required for the specific challenge type.
  ///
  /// Typical responses include:
  /// - 'USERNAME': The username of the authenticating user
  /// - 'SOFTWARE_TOKEN_MFA_CODE': TOTP code for MFA
  /// - 'SMS_MFA_CODE': SMS verification code
  /// - 'NEW_PASSWORD': New password for password change challenges
  /// - 'SECRET_HASH': HMAC calculated secret hash (for confidential clients)
  final Map<String, String> challengeResponses;

  /// Optional metadata passed to Lambda triggers during the challenge response.
  ///
  /// This metadata can be used by Custom Message, Pre Authentication,
  /// and other Lambda triggers in the authentication flow.
  final Map<String, String>? clientMetadata;

  /// Optional analytics metadata for Amazon Pinpoint analytics integration.
  ///
  /// This data is passed through to analytics services and can include
  /// information about the client application and user context.
  final Map<String, dynamic>? analyticsMetadata;

  /// Optional context data for advanced security and risk analysis.
  ///
  /// This data is used by Cognito's advanced security features to evaluate
  /// authentication risk and can include device fingerprinting, IP address,
  /// and other contextual information.
  final Map<String, dynamic>? contextData;

  /// Session token from the previous authentication step.
  ///
  /// This session token is required for multi-step authentication flows
  /// and is provided in the response from the previous challenge.
  final String? session;

  /// AWS region where the User Pool is located (e.g., "us-west-2").
  final String region;

  /// SigV4-capable HTTP client for making authenticated requests to AWS.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout duration (default: 20 seconds).
  final Duration requestTimeout;

  /// Creates a new AdminRespondToAuthChallenge request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [clientId]: Required - The application client ID
  /// - [challengeName]: Required - The type of challenge being responded to
  /// - [challengeResponses]: Required - Key/value pairs for challenge response
  /// - [region]: Required - AWS region identifier
  /// - [httpClient]: Required - HTTP client for making requests
  /// - [clientMetadata]: Optional - Metadata for Lambda triggers
  /// - [analyticsMetadata]: Optional - Analytics integration data
  /// - [contextData]: Optional - Advanced security context data
  /// - [session]: Optional - Session token from previous authentication step
  /// - [maxRetries]: Optional - Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional - Request timeout (default: 20 seconds)
  ///
  /// Throws [CognitoValidationException] if parameters are invalid.
  CognitoAdminRespondToAuthChallengeRequest({
    required this.userPoolId,
    required this.clientId,
    required this.challengeName,
    required this.challengeResponses,
    required this.region,
    required this.httpClient,
    this.clientMetadata,
    this.analyticsMetadata,
    this.contextData,
    this.session,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates request parameters according to AWS Cognito requirements.
  ///
  /// Performs validation of User Pool ID format, client ID presence,
  /// challenge name requirements, challenge responses, session token
  /// constraints, and metadata format validation.
  ///
  /// Throws [CognitoValidationException] if validation fails.
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (clientId.trim().isEmpty) {
      throw CognitoValidationException('clientId is required.');
    }
    if (challengeName.trim().isEmpty) {
      throw CognitoValidationException('challengeName is required.');
    }
    if (challengeResponses.isEmpty) {
      throw CognitoValidationException('challengeResponses must not be empty.');
    }
    if (session != null) {
      final len = session!.length;
      if (len < 20 || len > 2048) {
        throw CognitoValidationException(
          'session length must be between 20 and 2048 characters.',
        );
      }
    }
    if (clientMetadata != null) {
      for (final e in clientMetadata!.entries) {
        if (e.key.isEmpty) {
          throw CognitoValidationException(
            'clientMetadata keys must be non-empty.',
          );
        }
      }
    }
  }

  /// Constructs the JSON payload for the AdminRespondToAuthChallenge API call.
  ///
  /// Returns a Map containing all required and optional parameters formatted
  /// according to the AWS Cognito API specification.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'ClientId': clientId,
    'ChallengeName': challengeName,
    'ChallengeResponses': challengeResponses,
    if (clientMetadata != null) 'ClientMetadata': clientMetadata,
    if (analyticsMetadata != null) 'AnalyticsMetadata': analyticsMetadata,
    if (contextData != null) 'ContextData': contextData,
    if (session != null) 'Session': session,
  };

  /// Executes the AdminRespondToAuthChallenge API request.
  ///
  /// This method handles the complete challenge response flow including:
  /// 1. Parameter validation
  /// 2. Payload construction
  /// 3. Signed HTTP request with SigV4 authentication
  /// 4. Retry logic with incremental backoff for transient failures
  /// 5. Response parsing and error handling
  ///
  /// Returns:
  /// A Future that completes with [   CognitoAdminRespondToAuthChallengeResult]
  /// containing the raw response body and status code.
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for AWS service errors (4xx/5xx)
  /// - Other exceptions for network failures or unexpected errors
  Future<CognitoAdminRespondToAuthChallengeResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target:
              'AWSCognitoIdentityProviderService.AdminRespondToAuthChallenge',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return CognitoAdminRespondToAuthChallengeResult(
            body: res.bodyString,
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminRespondToAuthChallenge failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminRespondToAuthChallenge temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminRespondToAuthChallenge unexpected status.',
          statusCode: res.statusCode,
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
      'AdminRespondToAuthChallenge failed after retries. Last error: $lastError',
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
