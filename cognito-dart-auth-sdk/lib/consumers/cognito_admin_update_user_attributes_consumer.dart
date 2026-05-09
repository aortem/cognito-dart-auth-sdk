import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart'
    show CognitoAttributeType;
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_user_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Callback used to configure an AdminUpdateUserAttributes builder.
typedef CognitoAdminUpdateUserAttributesConsumerFn =
    void Function(CognitoAdminUpdateUserAttributesBuilder b);

/// Fluent builder for AdminUpdateUserAttributes requests.
class CognitoAdminUpdateUserAttributesBuilder {
  String? _userPoolId;
  String? _username;
  final List<CognitoAttributeType> _attributes = <CognitoAttributeType>[];
  final Map<String, String> _clientMetadata = <String, String>{};

  /// Sets the user pool ID.
  CognitoAdminUpdateUserAttributesBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username.
  CognitoAdminUpdateUserAttributesBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Adds an attribute update.
  CognitoAdminUpdateUserAttributesBuilder attribute(String name, String value) {
    _attributes.add(CognitoAttributeType(name: name.trim(), value: value));
    return this;
  }

  /// Adds client metadata for Cognito triggers.
  CognitoAdminUpdateUserAttributesBuilder metadata(String key, String value) {
    final trimmedKey = key.trim();
    if (trimmedKey.isEmpty) {
      throw CognitoValidationException('metadata key is required.');
    }
    _clientMetadata[trimmedKey] = value;
    return this;
  }

  /// Builds a validated request.
  CognitoAdminUpdateUserAttributesRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final userPoolId = _userPoolId ?? '';
    final username = _username ?? '';
    if (userPoolId.isEmpty) {
      throw CognitoValidationException('userPoolId is required.');
    }
    if (username.isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (_attributes.isEmpty) {
      throw CognitoValidationException(
        'At least one user attribute must be provided.',
      );
    }

    return CognitoAdminUpdateUserAttributesRequest(
      userPoolId: userPoolId,
      username: username,
      userAttributes: List.unmodifiable(_attributes),
      clientMetadata: _clientMetadata.isEmpty
          ? null
          : Map.unmodifiable(_clientMetadata),
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer facade for AdminUpdateUserAttributes.
class CognitoAdminUpdateUserAttributesConsumer {
  /// AWS region for Cognito requests.
  final String region;

  /// Configured Cognito HTTP client.
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts for transient failures.
  final int maxRetries;

  /// Per-request timeout.
  final Duration requestTimeout;

  /// Creates a consumer with shared request settings.
  CognitoAdminUpdateUserAttributesConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Builds and executes an AdminUpdateUserAttributes request.
  Future<CognitoAdminUpdateUserAttributesResult> run(
    CognitoAdminUpdateUserAttributesConsumerFn consumer,
  ) async {
    final builder = CognitoAdminUpdateUserAttributesBuilder();
    consumer(builder);
    final request = builder.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await request.execute();
  }
}
