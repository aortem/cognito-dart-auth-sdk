/// Consumer/builder-style facade for AdminConfirmSignUp operation.
///
/// Provides a fluent interface for building AdminConfirmSignUp requests
/// with runtime input validation and normalization.
library aortem_cognito_admin_confirm_sign_up_consumer;

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_confirm_sign_up_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// Function type for builder configuration callbacks
typedef AortemCognitoConfirmSignUpConsumerFn =
    void Function(AortemCognitoAdminConfirmSignUpBuilder b);

/// Builder class for constructing AdminConfirmSignUp requests.
///
/// Provides a fluent interface for setting parameters with validation.
class AortemCognitoAdminConfirmSignUpBuilder {
  /// Stores the user pool ID for the request
  String? _userPoolId;

  /// Stores the username to confirm
  String? _username;

  /// Stores client metadata for Lambda triggers
  final Map<String, String> _clientMetadata = <String, String>{};

  /// Sets the user pool ID for the confirmation request.
  ///
  /// @param value The user pool ID (format: [\w-]+_[0-9a-zA-Z]+)
  /// @return The builder instance for method chaining
  AortemCognitoAdminConfirmSignUpBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username to confirm.
  ///
  /// @param value The username to confirm
  /// @return The builder instance for method chaining
  AortemCognitoAdminConfirmSignUpBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Adds a single client metadata entry.
  ///
  /// @param key The metadata key (must be non-empty)
  /// @param value The metadata value
  /// @return The builder instance for method chaining
  /// @throws AortemCognitoValidationException if key is empty
  AortemCognitoAdminConfirmSignUpBuilder meta(String key, String value) {
    if (key.trim().isEmpty) {
      throw AortemCognitoValidationException(
        'ClientMetadata key must be non-empty.',
      );
    }
    _clientMetadata[key] = value;
    return this;
  }

  /// Adds multiple client metadata entries (merges with existing).
  ///
  /// @param data Map of metadata entries to add
  /// @return The builder instance for method chaining
  /// @throws AortemCognitoValidationException if any key is empty
  AortemCognitoAdminConfirmSignUpBuilder metadata(Map<String, String> data) {
    data.forEach((k, v) {
      if (k.trim().isEmpty) {
        throw AortemCognitoValidationException(
          'ClientMetadata key must be non-empty.',
        );
      }
      _clientMetadata[k] = v;
    });
    return this;
  }

  /// Builds the final request object after validation.
  ///
  /// @param region AWS region for the request
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20s)
  /// @return Configured AdminConfirmSignUp request
  /// @throws AortemCognitoValidationException if required fields are missing
  AortemCognitoAdminConfirmSignUpRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final pool = _userPoolId?.trim() ?? '';
    final user = _username?.trim() ?? '';

    if (pool.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (user.isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }

    return AortemCognitoAdminConfirmSignUpRequest(
      userPoolId: pool,
      username: user,
      clientMetadata: _clientMetadata.isEmpty ? null : Map.of(_clientMetadata),
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// High-level consumer for AdminConfirmSignUp operations.
///
/// Provides a simplified interface for executing confirmation requests
/// using the builder pattern.
class AortemCognitoAdminConfirmSignUpConsumer {
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
  AortemCognitoAdminConfirmSignUpConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the user confirmation flow.
  ///
  /// @param consumer Builder configuration callback
  /// @return Future resolving to confirmation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminConfirmSignUpResult> run(
    AortemCognitoConfirmSignUpConsumerFn consumer,
  ) async {
    final b = AortemCognitoAdminConfirmSignUpBuilder();
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
