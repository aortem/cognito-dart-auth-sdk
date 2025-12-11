//    cognito_admin_set_user_mfa_preference_consumer.dart

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_mfa_preference_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Typedef for a function that configures an AdminSetUserMFAPreference builder
/// using a fluent interface pattern.
///
/// This function type allows callers to provide MFA preference parameters
/// through method chaining while maintaining a clean, reusable interface.
typedef CognitoAdminSetUserMFAPreferenceFn =
    void Function(CognitoAdminSetUserMFAPreferenceBuilder b);

/// Builder class for constructing AdminSetUserMFAPreference requests with
/// a fluent interface pattern.
///
/// This builder provides a method-chaining API to configure all parameters
/// required for setting user MFA preferences in AWS Cognito as an administrator.
/// It supports configuring email, SMS, and software token MFA preferences.
class CognitoAdminSetUserMFAPreferenceBuilder {
  String? _userPoolId;
  String? _username;
  Map<String, dynamic>? _emailMfaSettings;
  Map<String, dynamic>? _smsMfaSettings;
  Map<String, dynamic>? _softwareTokenMfaSettings;

  /// Sets the User Pool ID where the user exists.
  ///
  /// This is a required parameter that identifies the Cognito User Pool
  /// for the MFA preference operation.
  ///
  /// Example:
  /// ```dart
  /// builder.userPoolId('us-west-2_EXAMPLE');
  /// ```
  CognitoAdminSetUserMFAPreferenceBuilder userPoolId(String v) {
    _userPoolId = v;
    return this;
  }

  /// Sets the username of the user whose MFA preferences are being configured.
  ///
  /// This is a required parameter that specifies which user account
  /// to update MFA preferences for.
  ///
  /// Example:
  /// ```dart
  /// builder.username('testuser');
  /// ```
  CognitoAdminSetUserMFAPreferenceBuilder username(String v) {
    _username = v;
    return this;
  }

  /// Sets the email MFA settings for the user.
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether email MFA is enabled
  /// - 'PreferredMfa': bool - Whether email MFA is the preferred method
  ///
  /// Example:
  /// ```dart
  /// builder.emailMfaSettings({
  ///   'Enabled': true,
  ///   'PreferredMfa': false,
  /// });
  /// ```
  CognitoAdminSetUserMFAPreferenceBuilder emailMfaSettings(
    Map<String, dynamic> v,
  ) {
    _emailMfaSettings = v;
    return this;
  }

  /// Sets the SMS MFA settings for the user.
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether SMS MFA is enabled
  /// - 'PreferredMfa': bool - Whether SMS MFA is the preferred method
  ///
  /// Example:
  /// ```dart
  /// builder.smsMfaSettings({
  ///   'Enabled': false,
  ///   'PreferredMfa': false,
  /// });
  /// ```
  CognitoAdminSetUserMFAPreferenceBuilder smsMfaSettings(
    Map<String, dynamic> v,
  ) {
    _smsMfaSettings = v;
    return this;
  }

  /// Sets the software token MFA (TOTP) settings for the user.
  ///
  /// Typically includes:
  /// - 'Enabled': bool - Whether software token MFA is enabled
  /// - 'PreferredMfa': bool - Whether software token MFA is the preferred method
  ///
  /// Example:
  /// ```dart
  /// builder.softwareTokenMfaSettings({
  ///   'Enabled': true,
  ///   'PreferredMfa': true,
  /// });
  /// ```
  CognitoAdminSetUserMFAPreferenceBuilder softwareTokenMfaSettings(
    Map<String, dynamic> v,
  ) {
    _softwareTokenMfaSettings = v;
    return this;
  }

  /// Constructs an AdminSetUserMFAPreference request instance.
  ///
  /// Combines all configured parameters into a ready-to-execute request object.
  /// Note: Validation of required parameters is handled by the request class itself.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the User Pool is located
  /// - [httpClient]: The HTTP client to use for the request
  /// - [maxRetries]: Maximum number of retry attempts for the request
  /// - [requestTimeout]: Timeout duration for the HTTP request
  ///
  /// Returns:
  /// A configured [   CognitoAdminSetUserMFAPreferenceRequest] instance
  CognitoAdminSetUserMFAPreferenceRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return CognitoAdminSetUserMFAPreferenceRequest(
      userPoolId: _userPoolId ?? '',
      username: _username ?? '',
      emailMfaSettings: _emailMfaSettings,
      smsMfaSettings: _smsMfaSettings,
      softwareTokenMfaSettings: _softwareTokenMfaSettings,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class that provides a reusable interface for executing
/// AdminSetUserMFAPreference operations with shared configuration.
///
/// This class encapsulates the common configuration (region, HTTP client,
/// retry settings, timeout) and provides a clean API for executing
/// MFA preference operations with different parameters for each call.
class CognitoAdminSetUserMFAPreferenceConsumer {
  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client used for making requests to AWS Cognito
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for HTTP requests
  final Duration requestTimeout;

  /// Creates a new AdminSetUserMFAPreference consumer with shared configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier (e.g., 'us-west-2')
  /// - [httpClient]: Required HTTP client instance for making requests
  /// - [maxRetries]: Optional maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional request timeout duration (default: 20 seconds)
  CognitoAdminSetUserMFAPreferenceConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminSetUserMFAPreference request with builder-style configuration.
  ///
  /// This method allows callers to provide request parameters through a
  /// fluent builder interface while reusing the consumer's shared configuration
  /// (region, HTTP client, retry settings, timeout).
  ///
  /// Example:
  /// ```dart
  /// final result = await consumer.run((b) => b
  ///   ..userPoolId('us-west-2_EXAMPLE')
  ///   ..username('testuser')
  ///   ..softwareTokenMfaSettings({
  ///     'Enabled': true,
  ///     'PreferredMfa': true,
  ///   }));
  /// ```
  ///
  /// Parameters:
  /// - [fn]: A function that receives and configures a builder instance
  ///
  /// Returns:
  /// A Future that completes with the result of the MFA preference operation
  ///
  /// Throws:
  /// - [   CognitoValidationException] if required parameters are missing
  /// - Various network and AWS Cognito service exceptions
  Future<CognitoAdminSetUserMFAPreferenceResult> run(
    CognitoAdminSetUserMFAPreferenceFn fn,
  ) async {
    final b = CognitoAdminSetUserMFAPreferenceBuilder();
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
