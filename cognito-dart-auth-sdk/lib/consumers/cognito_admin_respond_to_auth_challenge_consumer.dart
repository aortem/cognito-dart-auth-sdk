// admin_respond_to_auth_challenge_consumer.dart
//    cognito_admin_respond_to_auth_challenge_consumer.dart
//
// Consumer (builder) for AdminRespondToAuthChallenge.
// Lets callers provide parameters via a closure while reusing region/client.
//
// Example:
// final consumer =    CognitoAdminRespondToAuthChallengeConsumer(
//   region: 'us-west-2',
//   httpClient: client,
// );
// final res = await consumer.run((b) => b
//   ..userPoolId('us-west-2_EXAMPLE')
//   ..clientId('1example23456789')
//   ..challengeName('SOFTWARE_TOKEN_MFA')
//   ..challengeResponses({
//     'USERNAME': 'testuser',
//     'SOFTWARE_TOKEN_MFA_CODE': '123456',
//     'SECRET_HASH': '...'
//   })
//   ..session('EXAMPLE_SESSION_TOKEN_FROM_ADMININITIATEAUTH...'),
// );

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_respond_to_auth_challenge_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a function that configures an AdminRespondToAuthChallenge builder
/// using a fluent interface pattern.
///
/// This function type allows callers to provide challenge response parameters
/// through method chaining while maintaining a clean, reusable interface.
typedef CognitoAdminRespondToAuthChallengeFn =
    void Function(CognitoAdminRespondToAuthChallengeBuilder b);

/// Builder class for constructing AdminRespondToAuthChallenge requests with
/// a fluent interface pattern.
///
/// This builder provides a method-chaining API to configure all parameters
/// required for responding to authentication challenges in AWS Cognito.
/// It supports various challenge types including MFA, password, and custom challenges.
class CognitoAdminRespondToAuthChallengeBuilder {
  String? _userPoolId;
  String? _clientId;
  String? _challengeName;
  Map<String, String>? _challengeResponses;
  Map<String, String>? _clientMetadata;
  Map<String, dynamic>? _analyticsMetadata;
  Map<String, dynamic>? _contextData;
  String? _session;

  /// Sets the User Pool ID where the authentication challenge is being processed.
  ///
  /// This is a required parameter that identifies the Cognito User Pool
  /// for the authentication operation.
  ///
  /// Example:
  /// ```dart
  /// builder.userPoolId('us-west-2_EXAMPLE');
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder userPoolId(String v) {
    _userPoolId = v.trim();
    return this;
  }

  /// Sets the application client ID associated with the authentication request.
  ///
  /// This is a required parameter that identifies the Cognito App Client
  /// configured for the authentication flow.
  ///
  /// Example:
  /// ```dart
  /// builder.clientId('1example23456789');
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder clientId(String v) {
    _clientId = v.trim();
    return this;
  }

  /// Sets the challenge name indicating the type of challenge being responded to.
  ///
  /// This is a required parameter that specifies the challenge type.
  /// Common values include 'SOFTWARE_TOKEN_MFA', 'SMS_MFA', 'NEW_PASSWORD_REQUIRED'.
  ///
  /// Example:
  /// ```dart
  /// builder.challengeName('SOFTWARE_TOKEN_MFA');
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder challengeName(String v) {
    _challengeName = v.trim();
    return this;
  }

  /// Sets the challenge response key/value pairs required for the specific challenge.
  ///
  /// This is a required parameter that provides the actual response data
  /// for the challenge, such as MFA codes, passwords, or other verification data.
  ///
  /// Example:
  /// ```dart
  /// builder.challengeResponses({
  ///   'USERNAME': 'testuser',
  ///   'SOFTWARE_TOKEN_MFA_CODE': '123456',
  ///   'SECRET_HASH': 'calculated_hash_value'
  /// });
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder challengeResponses(
    Map<String, String> v,
  ) {
    _challengeResponses = v;
    return this;
  }

  /// Sets optional client metadata to be passed to Lambda triggers.
  ///
  /// This metadata can be used by Custom Message, Pre Authentication,
  /// and other Lambda triggers during the challenge response flow.
  ///
  /// Example:
  /// ```dart
  /// builder.clientMetadata({'source': 'mobile-app', 'version': '1.2.3'});
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder clientMetadata(
    Map<String, String> v,
  ) {
    _clientMetadata = v;
    return this;
  }

  /// Sets optional analytics metadata for Amazon Pinpoint integration.
  ///
  /// This data is passed through to analytics services and can include
  /// information about the client application and user context.
  ///
  /// Example:
  /// ```dart
  /// builder.analyticsMetadata({
  ///   'analyticsEndpointId': 'endpoint-123',
  ///   'platform': 'iOS'
  /// });
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder analyticsMetadata(
    Map<String, dynamic> v,
  ) {
    _analyticsMetadata = v;
    return this;
  }

  /// Sets optional context data for advanced security features.
  ///
  /// This data is used by Cognito's advanced security features for
  /// risk analysis and can include device fingerprinting and IP information.
  ///
  /// Example:
  /// ```dart
  /// builder.contextData({
  ///   'ipAddress': '192.168.1.1',
  ///   'deviceName': 'iPhone12,1'
  /// });
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder contextData(
    Map<String, dynamic> v,
  ) {
    _contextData = v;
    return this;
  }

  /// Sets the session token from the previous authentication step.
  ///
  /// This session token is required for multi-step authentication flows
  /// and is typically obtained from a previous AdminInitiateAuth response.
  ///
  /// Example:
  /// ```dart
  /// builder.session('EXAMPLE_SESSION_TOKEN_FROM_ADMININITIATEAUTH...');
  /// ```
  CognitoAdminRespondToAuthChallengeBuilder session(String v) {
    _session = v;
    return this;
  }

  /// Constructs and validates an AdminRespondToAuthChallenge request instance.
  ///
  /// Validates that all required parameters are provided and constructs
  /// a ready-to-execute request object with the provided configuration.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the User Pool is located
  /// - [httpClient]: The HTTP client to use for the request
  /// - [maxRetries]: Maximum number of retry attempts for the request
  /// - [requestTimeout]: Timeout duration for the HTTP request
  ///
  /// Throws [CognitoValidationException] if required parameters
  /// are missing or invalid.
  CognitoAdminRespondToAuthChallengeRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final cid = _clientId?.trim() ?? '';
    final cn = _challengeName?.trim() ?? '';
    final cr = _challengeResponses;

    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (cid.isEmpty) {
      throw CognitoValidationException('clientId is required.');
    }
    if (cn.isEmpty) {
      throw CognitoValidationException('challengeName is required.');
    }
    if (cr == null || cr.isEmpty) {
      throw CognitoValidationException('challengeResponses must not be empty.');
    }

    return CognitoAdminRespondToAuthChallengeRequest(
      userPoolId: up,
      clientId: cid,
      challengeName: cn,
      challengeResponses: cr,
      clientMetadata: _clientMetadata,
      analyticsMetadata: _analyticsMetadata,
      contextData: _contextData,
      session: _session,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class that provides a reusable interface for executing
/// AdminRespondToAuthChallenge operations with shared configuration.
///
/// This class encapsulates the common configuration (region, HTTP client,
/// retry settings, timeout) and provides a clean API for executing
/// challenge response operations with different parameters for each call.
class CognitoAdminRespondToAuthChallengeConsumer {
  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client used for making requests to AWS Cognito
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for HTTP requests
  final Duration requestTimeout;

  /// Creates a new AdminRespondToAuthChallenge consumer with shared configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier (e.g., 'us-west-2')
  /// - [httpClient]: Required HTTP client instance for making requests
  /// - [maxRetries]: Optional maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional request timeout duration (default: 20 seconds)
  CognitoAdminRespondToAuthChallengeConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminRespondToAuthChallenge request with builder-style configuration.
  ///
  /// This method allows callers to provide request parameters through a
  /// fluent builder interface while reusing the consumer's shared configuration
  /// (region, HTTP client, retry settings, timeout).
  ///
  /// Example:
  /// ```dart
  /// final result = await consumer.run((b) => b
  ///   ..userPoolId('us-west-2_EXAMPLE')
  ///   ..clientId('1example23456789')
  ///   ..challengeName('SOFTWARE_TOKEN_MFA')
  ///   ..challengeResponses({
  ///     'USERNAME': 'testuser',
  ///     'SOFTWARE_TOKEN_MFA_CODE': '123456'
  ///   })
  ///   ..session('session_token_from_previous_step'));
  /// ```
  ///
  /// Parameters:
  /// - [fn]: A function that receives and configures a builder instance
  ///
  /// Returns:
  /// A Future that completes with the result of the challenge response operation
  ///
  /// Throws:
  /// - [CognitoValidationException] if required parameters are missing
  /// - Various network and AWS Cognito service exceptions
  Future<CognitoAdminRespondToAuthChallengeResult> run(
    CognitoAdminRespondToAuthChallengeFn fn,
  ) async {
    final b = CognitoAdminRespondToAuthChallengeBuilder();
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
