// admin_link_provider_for_user_consumer.dart
//    cognito_admin_link_provider_for_user_consumer.dart
//
// Consumer/builder-style facade for AdminLinkProviderForUser operation.
// Provides a fluent interface for linking external identity provider (IdP) identities
// to existing Cognito users using admin privileges.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_link_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Functional interface for configuring AdminLinkProviderForUser requests via builder.
///
/// Used with [   CognitoAdminLinkProviderForUserConsumer.run] to dynamically
/// build identity linking requests before sending them to Cognito.
typedef CognitoAdminLinkProviderForUserConsumerFn =
    void Function(CognitoAdminLinkProviderForUserBuilder b);

/// Fluent builder for constructing AdminLinkProviderForUser requests.
///
/// Provides a chainable interface for:
/// - Setting the target user pool
/// - Configuring both source (external IdP) and destination (Cognito) users
/// - Building the final validated request
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminLinkProviderForUserBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..destinationUser(
///     providerName: 'Cognito',
///     providerAttributeValue: 'local_username'
///   )
///   ..sourceUser(
///     providerName: 'Google',
///     providerAttributeName: 'Cognito_Subject',
///     providerAttributeValue: 'google_user_id'
///   );
/// ```
class CognitoAdminLinkProviderForUserBuilder {
  String? _userPoolId;
  CognitoProviderUserLinkingIdentifier? _destinationUser;
  CognitoProviderUserLinkingIdentifier? _sourceUser;

  /// Sets the User Pool ID for the linking operation.
  ///
  /// Parameters:
  /// - [value]: The Cognito User Pool ID (format: region_id)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminLinkProviderForUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the destination user (existing Cognito user).
  ///
  /// Parameters:
  /// - [providerName]: Must be "Cognito" for local users
  /// - [providerAttributeValue]: The Cognito username
  /// - [providerAttributeName]: Optional (ignored by service for destination users)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminLinkProviderForUserBuilder destinationUser({
    required String providerName,
    required String providerAttributeValue,
    String? providerAttributeName,
  }) {
    _destinationUser = CognitoProviderUserLinkingIdentifier(
      providerName: providerName,
      providerAttributeValue: providerAttributeValue,
      providerAttributeName: providerAttributeName,
    );
    return this;
  }

  /// Sets the source user (external IdP identity to link).
  ///
  /// Parameters:
  /// - [providerName]: The external IdP name (e.g., "Google", "Facebook")
  /// - [providerAttributeValue]: The unique user identifier from the IdP
  /// - [providerAttributeName]: Typically "Cognito_Subject" for social IdPs
  ///
  /// Returns the builder for method chaining.
  CognitoAdminLinkProviderForUserBuilder sourceUser({
    required String providerName,
    required String providerAttributeValue,
    String? providerAttributeName,
  }) {
    _sourceUser = CognitoProviderUserLinkingIdentifier(
      providerName: providerName,
      providerAttributeValue: providerAttributeValue,
      providerAttributeName: providerAttributeName,
    );
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
  /// - Configured [   CognitoAdminLinkProviderForUserRequest]
  ///
  /// Throws:
  /// - [CognitoValidationException] if required fields are missing
  CognitoAdminLinkProviderForUserRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (_destinationUser == null) {
      throw CognitoValidationException('destinationUser is required.');
    }
    if (_sourceUser == null) {
      throw CognitoValidationException('sourceUser is required.');
    }

    return CognitoAdminLinkProviderForUserRequest(
      userPoolId: up,
      destinationUser: _destinationUser!,
      sourceUser: _sourceUser!,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer-style facade for AdminLinkProviderForUser operation.
///
/// Provides a higher-level interface for building and executing identity
/// linking requests using the builder pattern.
class CognitoAdminLinkProviderForUserConsumer {
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
  CognitoAdminLinkProviderForUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to link provider identities.
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
  /// - [   CognitoAdminLinkProviderForUserResult] on success
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [   CognitoServiceException] for API failures
  Future<CognitoAdminLinkProviderForUserResult> run(
    CognitoAdminLinkProviderForUserConsumerFn fn,
  ) async {
    final b = CognitoAdminLinkProviderForUserBuilder();
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
