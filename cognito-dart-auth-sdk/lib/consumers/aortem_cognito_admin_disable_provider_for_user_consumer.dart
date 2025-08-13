/// Consumer/builder-style facade for AdminDisableProviderForUser operation.
///
/// Provides a fluent interface for building requests to disable specific
/// identity providers for users in Cognito user pools.
library aortem_cognito_admin_disable_provider_for_user_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_disable_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef AortemCognitoDisableProviderConsumerFn =
    void Function(AortemCognitoAdminDisableProviderForUserBuilder b);

/// Builder class for constructing AdminDisableProviderForUser requests.
///
/// Provides a fluent interface for setting parameters with validation.
class AortemCognitoAdminDisableProviderForUserBuilder {
  /// Stores the user pool ID
  String? _userPoolId;

  /// Stores the identity provider name
  String? _providerName;

  /// Stores the provider attribute name
  String? _providerAttributeName;

  /// Stores the provider attribute value
  String? _providerAttributeValue;

  /// Sets the user pool ID for the request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableProviderForUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the identity provider name.
  ///
  /// @param value The provider name (e.g., 'Google', 'Facebook', 'Cognito')
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableProviderForUserBuilder providerName(String value) {
    _providerName = value.trim();
    return this;
  }

  /// Sets the provider attribute name (typically 'Cognito_Subject').
  ///
  /// @param value The attribute name used by the provider
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableProviderForUserBuilder providerAttributeName(
    String value,
  ) {
    _providerAttributeName = value.trim();
    return this;
  }

  /// Sets the provider attribute value (subject identifier or username).
  ///
  /// @param value The unique identifier from the provider
  /// @return The builder instance for method chaining
  AortemCognitoAdminDisableProviderForUserBuilder providerAttributeValue(
    String value,
  ) {
    _providerAttributeValue = value.trim();
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminDisableProviderForUser request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminDisableProviderForUserRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final pn = _providerName?.trim() ?? '';
    final pan = _providerAttributeName?.trim() ?? '';
    final pav = _providerAttributeValue?.trim() ?? '';

    if (up.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (pn.isEmpty) {
      throw AortemCognitoValidationException('providerName is required.');
    }
    if (pan.isEmpty) {
      throw AortemCognitoValidationException(
        'providerAttributeName is required.',
      );
    }
    if (pav.isEmpty) {
      throw AortemCognitoValidationException(
        'providerAttributeValue is required.',
      );
    }

    final id = AortemCognitoProviderUserIdentifier(
      providerName: pn,
      providerAttributeName: pan,
      providerAttributeValue: pav,
    );

    return AortemCognitoAdminDisableProviderForUserRequest(
      userPoolId: up,
      user: id,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminDisableProviderForUser operations.
///
/// Provides a simplified interface for executing provider disable requests
/// using the builder pattern.
class AortemCognitoAdminDisableProviderForUserConsumer {
  /// AWS region for the Cognito endpoint
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for requests (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new consumer instance.
  ///
  /// @param region AWS region for Cognito endpoint
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  AortemCognitoAdminDisableProviderForUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the provider disable flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to operation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminDisableProviderForUserResult> run(
    AortemCognitoDisableProviderConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminDisableProviderForUserBuilder();
    consumer(b);

    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }
}
