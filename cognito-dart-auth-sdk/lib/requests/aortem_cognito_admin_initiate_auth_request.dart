// admin_initiate_auth_request.dart
// File: aortem_cognito_admin_initiate_auth_request.dart
//
// Implements the AdminInitiateAuth operation for AWS Cognito
// This starts server-side authentication flows for admin users
// Target service: AWSCognitoIdentityProviderService.AdminInitiateAuth
//
// Dependencies:
// - AortemCognitoHttpClient for making authenticated requests
// - AortemCognitoValidationException for input validation errors
// - AortemCognitoServiceException for API/service errors

// Import required dependencies
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Represents the successful authentication result from Cognito
/// Contains all tokens and device metadata returned upon successful authentication
class AortemCognitoAuthenticationResult {
  /// JWT access token for making authenticated API calls
  final String? accessToken;

  /// JWT ID token containing user claims
  final String? idToken;

  /// Refresh token for obtaining new access/id tokens
  final String? refreshToken;

  /// Type of token (typically "Bearer")
  final String? tokenType;

  /// Time in seconds until tokens expire
  final int? expiresIn;

  /// Device key if new device is being registered
  final String? newDeviceKey;

  /// Device group key if new device is being registered
  final String? newDeviceGroupKey;

  /// Constructs an authentication result with all possible tokens/metadata
  const AortemCognitoAuthenticationResult({
    this.accessToken,
    this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.newDeviceKey,
    this.newDeviceGroupKey,
  });

  /// Parses authentication result from Cognito API JSON response
  factory AortemCognitoAuthenticationResult.fromJson(Map<String, dynamic> m) {
    // Extract new device metadata if present
    final nd = m['NewDeviceMetadata'] as Map<String, dynamic>?;

    return AortemCognitoAuthenticationResult(
      accessToken: m['AccessToken']?.toString(),
      idToken: m['IdToken']?.toString(),
      refreshToken: m['RefreshToken']?.toString(),
      tokenType: m['TokenType']?.toString(),
      expiresIn: (m['ExpiresIn'] is num)
          ? (m['ExpiresIn'] as num).toInt()
          : null,
      newDeviceKey: nd?['DeviceKey']?.toString(),
      newDeviceGroupKey: nd?['DeviceGroupKey']?.toString(),
    );
  }
}

/// Container for AdminInitiateAuth API response
/// Either contains successful auth result or challenge data if additional steps are needed
class AortemCognitoAdminInitiateAuthResult {
  /// Authentication tokens if authentication completed successfully
  final AortemCognitoAuthenticationResult? authenticationResult;

  /// Name of challenge if additional auth steps are required
  final String? challengeName;

  /// Parameters needed to complete the challenge
  final Map<String, String> challengeParameters;

  /// List of possible challenge types that could be requested
  final List<String> availableChallenges;

  /// Session identifier for multi-step authentication flows
  final String? session;

  /// Constructs an auth result with either tokens or challenge data
  const AortemCognitoAdminInitiateAuthResult({
    required this.authenticationResult,
    required this.challengeName,
    required this.challengeParameters,
    required this.availableChallenges,
    required this.session,
  });

  /// Parses AdminInitiateAuth response from HTTP response
  factory AortemCognitoAdminInitiateAuthResult.fromHttp(
    AortemCognitoHttpResponse res,
  ) {
    // Get JSON body or empty map if null
    final json = res.jsonBody ?? const <String, dynamic>{};

    // Parse authentication result if present
    AortemCognitoAuthenticationResult? auth;
    final ar = json['AuthenticationResult'];
    if (ar is Map<String, dynamic>) {
      auth = AortemCognitoAuthenticationResult.fromJson(ar);
    }

    // Parse challenge parameters
    final cpMap = <String, String>{};
    final cp = json['ChallengeParameters'];
    if (cp is Map) {
      cp.forEach((k, v) {
        cpMap[k.toString()] = v?.toString() ?? '';
      });
    }

    // Parse available challenges list
    final acListRaw = json['AvailableChallenges'] as List<dynamic>?;
    final acList =
        acListRaw?.map((e) => e.toString()).toList() ?? const <String>[];

    return AortemCognitoAdminInitiateAuthResult(
      authenticationResult: auth,
      challengeName: json['ChallengeName']?.toString(),
      challengeParameters: cpMap,
      availableChallenges: acList,
      session: json['Session']?.toString(),
    );
  }
}

/// Client for making AdminInitiateAuth requests to AWS Cognito
/// Handles authentication flows for admin users including password, SRP, and custom auth
class AortemCognitoAdminInitiateAuthRequest {
  /// Cognito User Pool ID (format: region_identifier)
  final String userPoolId;

  /// Application client ID
  final String clientId;

  /// Authentication flow type to use
  final String authFlow;

  /// Authentication parameters specific to the chosen flow
  final Map<String, String> authParameters;

  /// Additional client metadata to pass to Cognito
  final Map<String, String>? clientMetadata;

  /// Context data for advanced security features
  final Map<String, dynamic>? contextData;

  /// Analytics metadata for tracking
  final Map<String, dynamic>? analyticsMetadata;

  /// Session identifier for multi-step auth flows
  final String? session;

  /// AWS region where User Pool is located
  final String region;

  /// HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for the request
  final Duration requestTimeout;

  /// Set of allowed authentication flow types
  static const _allowedFlows = <String>{
    'USER_SRP_AUTH',
    'REFRESH_TOKEN_AUTH',
    'REFRESH_TOKEN',
    'CUSTOM_AUTH',
    'ADMIN_NO_SRP_AUTH',
    'USER_PASSWORD_AUTH', // technically valid on InitiateAuth; included for parity if reused.
    'ADMIN_USER_PASSWORD_AUTH',
    'USER_AUTH',
  };

  /// Constructs a new AdminInitiateAuth request
  AortemCognitoAdminInitiateAuthRequest({
    required this.userPoolId,
    required this.clientId,
    required this.authFlow,
    required this.authParameters,
    required this.region,
    required this.httpClient,
    this.clientMetadata,
    this.contextData,
    this.analyticsMetadata,
    this.session,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate(); // Validate parameters on construction
  }

  /// Validates all request parameters
  void _validate() {
    // Validate User Pool ID format
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }

    // Validate Client ID format and length
    final clientIdRe = RegExp(r'^[\w+]+$');
    if (clientId.trim().isEmpty ||
        clientId.length > 128 ||
        !clientIdRe.hasMatch(clientId)) {
      throw AortemCognitoValidationException(
        'clientId must be 1..128 chars and match [\\w+]+.',
      );
    }

    // Validate auth flow is supported
    if (!_allowedFlows.contains(authFlow)) {
      throw AortemCognitoValidationException(
        'Unsupported authFlow "$authFlow". Allowed: ${_allowedFlows.join(", ")}.',
      );
    }

    // Validate auth parameters
    for (final e in authParameters.entries) {
      if (e.key.isEmpty) {
        throw AortemCognitoValidationException(
          'AuthParameters contains empty key.',
        );
      }
    }
  }

  /// Builds the request payload for Cognito API
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'ClientId': clientId,
    'AuthFlow': authFlow,
    if (authParameters.isNotEmpty) 'AuthParameters': authParameters,
    if (clientMetadata != null) 'ClientMetadata': clientMetadata,
    if (contextData != null) 'ContextData': contextData,
    if (analyticsMetadata != null) 'AnalyticsMetadata': analyticsMetadata,
    if (session != null) 'Session': session,
  };

  /// Executes the AdminInitiateAuth request
  /// Returns authentication result or challenge data if additional steps are needed
  Future<AortemCognitoAdminInitiateAuthResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    // Retry loop with exponential backoff
    while (attempt <= maxRetries) {
      try {
        // Make HTTP request to Cognito
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminInitiateAuth',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        // Handle successful response
        if (res.statusCode == 200) {
          return AortemCognitoAdminInitiateAuthResult.fromHttp(res);
        }

        // Handle client errors (4xx)
        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminInitiateAuth failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        // Handle server errors (5xx)
        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminInitiateAuth temporary failure.',
            statusCode: res.statusCode,
          );
        }

        // Handle unexpected status codes
        throw AortemCognitoServiceException(
          'AdminInitiateAuth unexpected status.',
          statusCode: res.statusCode,
        );
      } catch (e) {
        lastError = e;
        final transient = _isTransient(e);

        // Break if non-transient error or max retries reached
        if (!transient || attempt == maxRetries) break;

        // Exponential backoff before retry
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    // All retries failed
    throw AortemCognitoServiceException(
      'AdminInitiateAuth failed after retries. Last error: $lastError',
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
