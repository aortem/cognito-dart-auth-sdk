// admin_initiate_auth_consumer.dart
// aortem_cognito_admin_initiate_auth_consumer.dart
//
// Consumer/builder-style facade for AdminInitiateAuth operation.
// Provides a fluent interface for initiating admin authentication flows
// with AWS Cognito User Pools.

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_initiate_auth_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// Functional interface for configuring AdminInitiateAuth requests via builder.
///
/// Used with [AortemCognitoAdminInitiateAuthConsumer.run] to dynamically
/// build authentication requests before sending them to Cognito.
typedef AortemCognitoAdminInitiateAuthConsumerFn =
    void Function(AortemCognitoAdminInitiateAuthBuilder b);

/// Fluent builder for constructing AdminInitiateAuth requests.
///
/// Provides a chainable interface for:
/// - Setting required authentication parameters
/// - Adding optional metadata
/// - Building the final validated request
///
/// Example:
/// ```dart
/// final builder = AortemCognitoAdminInitiateAuthBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..clientId('1example23456789')
///   ..authFlow('ADMIN_USER_PASSWORD_AUTH')
///   ..authParameters({
///     'USERNAME': 'testuser',
///     'PASSWORD': 'Password!123'
///   });
/// ```
class AortemCognitoAdminInitiateAuthBuilder {
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
  AortemCognitoAdminInitiateAuthBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the Client ID for the app client.
  ///
  /// Parameters:
  /// - [value]: The app client ID configured in Cognito
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder clientId(String value) {
    _clientId = value.trim();
    return this;
  }

  /// Sets the authentication flow type.
  ///
  /// Parameters:
  /// - [value]: The auth flow type (e.g., 'ADMIN_USER_PASSWORD_AUTH')
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder authFlow(String value) {
    _authFlow = value.trim();
    return this;
  }

  /// Sets the authentication parameters.
  ///
  /// Parameters:
  /// - [params]: Map of auth parameters (e.g., USERNAME/PASSWORD)
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder authParameters(
    Map<String, String> params,
  ) {
    _authParameters = Map<String, String>.from(params);
    return this;
  }

  /// Sets optional client metadata.
  ///
  /// Parameters:
  /// - [meta]: Key-value pairs of client metadata
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder clientMetadata(
    Map<String, String> meta,
  ) {
    _clientMetadata = Map<String, String>.from(meta);
    return this;
  }

  /// Sets context data for advanced security features.
  ///
  /// Parameters:
  /// - [ctx]: Context data map
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder contextData(Map<String, dynamic> ctx) {
    _contextData = Map<String, dynamic>.from(ctx);
    return this;
  }

  /// Sets analytics metadata.
  ///
  /// Parameters:
  /// - [am]: Analytics metadata map
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder analyticsMetadata(
    Map<String, dynamic> am,
  ) {
    _analyticsMetadata = Map<String, dynamic>.from(am);
    return this;
  }

  /// Sets the session token for challenge responses.
  ///
  /// Parameters:
  /// - [s]: Session token string
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAdminInitiateAuthBuilder session(String s) {
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
  /// - Configured [AortemCognitoAdminInitiateAuthRequest]
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if required fields are missing
  AortemCognitoAdminInitiateAuthRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final ci = _clientId?.trim() ?? '';
    final af = _authFlow?.trim() ?? '';

    if (up.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (ci.isEmpty) {
      throw AortemCognitoValidationException('clientId is required.');
    }
    if (af.isEmpty) {
      throw AortemCognitoValidationException('authFlow is required.');
    }

    return AortemCognitoAdminInitiateAuthRequest(
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
class AortemCognitoAdminInitiateAuthConsumer {
  /// The AWS region for Cognito requests
  final String region;

  /// The HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

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
  AortemCognitoAdminInitiateAuthConsumer({
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
  /// - [AortemCognitoAdminInitiateAuthResult] with authentication response
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid parameters
  /// - [AortemCognitoServiceException] for API failures
  Future<AortemCognitoAdminInitiateAuthResult> run(
    AortemCognitoAdminInitiateAuthConsumerFn fn,
  ) async {
    final b = AortemCognitoAdminInitiateAuthBuilder();
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
