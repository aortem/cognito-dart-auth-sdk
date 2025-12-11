// cognito_admin_create_user_consumer.dart
//
// Consumer/builder-style facade for AdminCreateUser.
// Lets callers fluently compose payload (username, attributes, delivery mediums,
// metadata, temporary password, etc.) and then executes Ticket #7 request.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// A function type that configures an [ CognitoAdminCreateUserBuilder].
typedef CognitoCreateUserConsumerFn =
    void Function(CognitoAdminCreateUserBuilder b);

/// A fluent builder for constructing AdminCreateUser requests to Amazon Cognito.
///
/// This builder pattern allows for easy composition of all parameters needed
/// to create a new user in a Cognito User Pool through the AdminCreateUser API.
///
/// Example:
/// ```dart
/// final result = await     (...).run((b) {
///   b.userPoolId('us-east-1_abc123')
///    .username('johndoe')
///    .email('john@example.com')
///    .phoneNumber('+15551234567')
///    .deliveryEmail()
///    .temporaryPassword('TempPass123!');
/// });
/// ```
class CognitoAdminCreateUserBuilder {
  String? _userPoolId;
  String? _username;

  final Map<String, String> _clientMetadata = <String, String>{};
  final List<CognitoAttributeType> _userAttributes = <CognitoAttributeType>[];
  final List<CognitoAttributeType> _validationData = <CognitoAttributeType>[];
  final Set<String> _desiredDeliveryMediums = <String>{}; // 'SMS', 'EMAIL'

  bool? _forceAliasCreation;
  CognitoMessageActionType? _messageAction;
  String? _temporaryPassword;

  /// Sets the User Pool ID where the user will be created.
  ///
  /// This is a required parameter. The value will be trimmed of whitespace.
  CognitoAdminCreateUserBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username for the new user.
  ///
  /// This is a required parameter. The value will be trimmed of whitespace.
  CognitoAdminCreateUserBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Adds a standard user attribute with the given [name] and [value].
  ///
  /// Standard attributes include things like 'email', 'phone_number', 'name', etc.
  CognitoAdminCreateUserBuilder attr(String name, String value) {
    _userAttributes.add(CognitoAttributeType(name: name, value: value));
    return this;
  }

  /// Adds a custom attribute, automatically ensuring it has the 'custom:' prefix.
  ///
  /// If [nameWithoutPrefix] already starts with 'custom:', it will be used as-is.
  /// Otherwise, the prefix will be added automatically.
  CognitoAdminCreateUserBuilder customAttr(
    String nameWithoutPrefix,
    String value,
  ) {
    final norm = nameWithoutPrefix.startsWith('custom:')
        ? nameWithoutPrefix
        : 'custom:${nameWithoutPrefix.trim()}';
    return attr(norm, value);
  }

  /// Convenience method to add the standard 'email' attribute.
  CognitoAdminCreateUserBuilder email(String email) => attr('email', email);

  /// Convenience method to add the standard 'phone_number' attribute (in E.164 format).
  CognitoAdminCreateUserBuilder phoneNumber(String e164) =>
      attr('phone_number', e164);

  /// Specifies that the welcome message should be delivered via email.
  CognitoAdminCreateUserBuilder deliveryEmail() {
    _desiredDeliveryMediums.add('EMAIL');
    return this;
  }

  /// Specifies that the welcome message should be delivered via SMS.
  CognitoAdminCreateUserBuilder deliverySms() {
    _desiredDeliveryMediums.add('SMS');
    return this;
  }

  /// Specifies multiple delivery mediums for the welcome message.
  ///
  /// Valid values are 'EMAIL' and 'SMS'.
  CognitoAdminCreateUserBuilder delivery(List<String> mediums) {
    for (final m in mediums) {
      _desiredDeliveryMediums.add(m);
    }
    return this;
  }

  /// Specifies that no welcome message should be sent to the user.
  CognitoAdminCreateUserBuilder messageSuppress() {
    _messageAction = CognitoMessageActionType.suppress;
    return this;
  }

  /// Specifies that the welcome message should be resent,
  /// even if the user already exists.
  CognitoAdminCreateUserBuilder messageResend() {
    _messageAction = CognitoMessageActionType.resend;
    return this;
  }

  /// Sets a temporary password for the new user.
  ///
  /// If not specified, Cognito will generate a temporary password.
  CognitoAdminCreateUserBuilder temporaryPassword(String password) {
    _temporaryPassword = password;
    return this;
  }

  /// Sets whether to force alias creation.
  ///
  /// If true, the alias (email or phone number) will be marked as verified
  /// even if it's already used by another user.
  CognitoAdminCreateUserBuilder forceAliasCreation(bool value) {
    _forceAliasCreation = value;
    return this;
  }

  /// Adds a key-value pair to the client metadata.
  ///
  /// This metadata is passed to pre-signup Lambda triggers.
  /// Throws [CognitoValidationException] if key is empty.
  CognitoAdminCreateUserBuilder meta(String key, String value) {
    if (key.trim().isEmpty) {
      throw CognitoValidationException('clientMetadata key must be non-empty.');
    }
    _clientMetadata[key] = value;
    return this;
  }

  /// Adds multiple key-value pairs to the client metadata.
  ///
  /// See [meta] for details about client metadata.
  CognitoAdminCreateUserBuilder metadata(Map<String, String> kv) {
    kv.forEach((k, v) => meta(k, v));
    return this;
  }

  /// Adds a validation attribute for pre-sign-up triggers.
  ///
  /// These attributes are temporary and only available during the pre-signup flow.
  CognitoAdminCreateUserBuilder validation(String name, String value) {
    _validationData.add(CognitoAttributeType(name: name, value: value));
    return this;
  }

  /// Constructs an [CognitoAdminCreateUserRequest] with the current configuration.
  ///
  /// Validates that required parameters (userPoolId and username) are set.
  /// Throws [CognitoValidationException] if validation fails.
  CognitoAdminCreateUserRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    if (up.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw CognitoValidationException('username is required.');
    }

    return CognitoAdminCreateUserRequest(
      userPoolId: up,
      username: un,
      region: region,
      httpClient: httpClient,
      userAttributes: _userAttributes.isEmpty
          ? null
          : List.unmodifiable(_userAttributes),
      desiredDeliveryMediums: _desiredDeliveryMediums.isEmpty
          ? null
          : List.unmodifiable(_desiredDeliveryMediums),
      forceAliasCreation: _forceAliasCreation,
      messageAction: _messageAction,
      temporaryPassword: _temporaryPassword,
      clientMetadata: _clientMetadata.isEmpty
          ? null
          : Map.unmodifiable(_clientMetadata),
      validationData: _validationData.isEmpty
          ? null
          : List.unmodifiable(_validationData),
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// A high-level consumer for executing AdminCreateUser operations.
///
/// This class provides a convenient way to execute Cognito AdminCreateUser
/// operations using a builder pattern for request configuration.
class CognitoAdminCreateUserConsumer {
  /// The AWS region where the User Pool is located.
  final String region;

  /// The HTTP client to use for making requests.
  final CognitoHttpClient httpClient;

  /// The maximum number of retries for failed requests.
  final int maxRetries;

  /// The timeout duration for the request.
  final Duration requestTimeout;

  /// Creates a new consumer with the given configuration.
  CognitoAdminCreateUserConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminCreateUser operation with the given configuration.
  ///
  /// The [consumer] function is called with a builder that can be used to
  /// configure the request parameters. Returns a Future that completes with
  /// the operation result.
  Future<CognitoAdminCreateUserResult> run(
    CognitoCreateUserConsumerFn consumer,
  ) async {
    final b = CognitoAdminCreateUserBuilder();
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
