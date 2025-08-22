// admin_initiate_auth_consumer.dart
//    cognito_admin_initiate_auth_consumer.dart
//
// Consumer/builder-style facade for AdminInitiateAuth operation.
// Provides a fluent interface for initiating admin authentication flows
// with AWS Cognito User Pools.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_initiate_auth_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Functional interface for configuring AdminInitiateAuth requests via builder.
///
/// Used with [   CognitoAdminInitiateAuthConsumer.run] to dynamically
/// build authentication requests before sending them to Cognito.
typedef CognitoAdminInitiateAuthConsumerFn =
    void Function(CognitoAdminInitiateAuthBuilder b);

/// Fluent builder for constructing AdminInitiateAuth requests.
///
/// Provides a chainable interface for:
/// - Setting required authentication parameters
/// - Adding optional metadata
/// - Building the final validated request
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminInitiateAuthBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..clientId('1example23456789')
///   ..authFlow('ADMIN_USER_PASSWORD_AUTH')
///   ..authParameters({
///     'USERNAME': 'testuser',
///     'PASSWORD': 'Password!123'
///   });
/// ```
class CognitoAdminInitiateAuthBuilder {
  String? _userPoolId;
  String? _clientId;
  String? _authFlow;
  Map<String, String> _authParameters = <String, String>{};
  Map<String, String>? _clientMetadata;
  Map<String, dynamic>? _contextData;
  Map<String, dynamic>? _analyticsMetadata;
  String? _session;

  /// Sets the User Pool ID for authentication.
  ///
  /// Parameters:
  /// - [value]: The Cognito User Pool ID (format: region_id)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the Client ID for the app client.
  ///
  /// Parameters:
  /// - [value]: The app client ID configured in Cognito
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder clientId(String value) {
    _clientId = value.trim();
    return this;
  }

  /// Sets the authentication flow type.
  ///
  /// Parameters:
  /// - [value]: The auth flow type (e.g., 'ADMIN_USER_PASSWORD_AUTH')
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder authFlow(String value) {
    _authFlow = value.trim();
    return this;
  }

  /// Sets the authentication parameters.
  ///
  /// Parameters:
  /// - [params]: Map of auth parameters (e.g., USERNAME/PASSWORD)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder authParameters(Map<String, String> params) {
    _authParameters = Map<String, String>.from(params);
    return this;
  }

  /// Sets optional client metadata.
  ///
  /// Parameters:
  /// - [meta]: Key-value pairs of client metadata
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder clientMetadata(Map<String, String> meta) {
    _clientMetadata = Map<String, String>.from(meta);
    return this;
  }

  /// Sets context data for advanced security features.
  ///
  /// Parameters:
  /// - [ctx]: Context data map
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder contextData(Map<String, dynamic> ctx) {
    _contextData = Map<String, dynamic>.from(ctx);
    return this;
  }

  /// Sets analytics metadata.
  ///
  /// Parameters:
  /// - [am]: Analytics metadata map
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder analyticsMetadata(Map<String, dynamic> am) {
    _analyticsMetadata = Map<String, dynamic>.from(am);
    return this;
  }

  /// Sets the session token for challenge responses.
  ///
  /// Parameters:
  /// - [s]: Session token string
  ///
  /// Returns the builder for method chaining.
  CognitoAdminInitiateAuthBuilder session(String s) {
    _session = s;
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
  /// - Configured [   CognitoAdminInitiateAuthRequest]
  ///
  /// Throws:
  /// - [CognitoValidationException] if required fields are missing
  CognitoAdminInitiateAuthRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final ci = _clientId?.trim() ?? '';
    final af = _authFlow?.trim() ?? '';

    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (ci.isEmpty) {
      throw CognitoValidationException('clientId is required.');
    }
    if (af.isEmpty) {
      throw CognitoValidationException('authFlow is required.');
    }

    return CognitoAdminInitiateAuthRequest(
      userPoolId: up,
      clientId: ci,
      authFlow: af,
      authParameters: _authParameters,
      clientMetadata: _clientMetadata,
      contextData: _contextData,
      analyticsMetadata: _analyticsMetadata,
      session: _session,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer-style facade for AdminInitiateAuth operation.
///
/// Provides a higher-level interface for building and executing authentication
/// requests using the builder pattern.
class CognitoAdminInitiateAuthConsumer {
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
  CognitoAdminInitiateAuthConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to initiate authentication.
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
  /// - [   CognitoAdminInitiateAuthResult] with authentication response
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [   CognitoServiceException] for API failures
  Future<CognitoAdminInitiateAuthResult> run(
    CognitoAdminInitiateAuthConsumerFn fn,
  ) async {
    final b = CognitoAdminInitiateAuthBuilder();
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
