// cognito_admin_delete_user_attributes_consumer.dart
//
// Consumer/builder-style facade for AdminDeleteUserAttributes.
// Provides a fluent interface for building requests to delete user attributes
// using admin privileges in AWS Cognito User Pools.

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Functional interface for defining attribute deletion requests via builder.
///
/// Used with [ CognitoAdminDeleteUserAttributesConsumer.run] to dynamically
/// build attribute deletion requests before sending them to Cognito.
typedef CognitoDeleteUserAttrsConsumerFn =
    void Function(CognitoAdminDeleteUserAttributesBuilder b);

/// Fluent builder for constructing AdminDeleteUserAttributes requests.
///
/// Provides a chainable interface for:
/// - Setting the target user pool and username
/// - Adding attribute names to delete
/// - Building the final validated request
class CognitoAdminDeleteUserAttributesBuilder {
  String? _userPoolId;
  String? _username;
  final List<String> _attributeNames = <String>[];

  /// Sets the target User Pool ID.
  ///
  /// Parameters:
  /// - [value]: The Cognito User Pool ID (must match `[\\w-]+_[0-9a-zA-Z]+`)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminDeleteUserAttributesBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the target username.
  ///
  /// Parameters:
  /// - [value]: The username or alias to delete attributes from (length 1-128)
  ///
  /// Returns the builder for method chaining.
  CognitoAdminDeleteUserAttributesBuilder username(String value) {
    _username = value.trim();
    return this;
  }

  /// Adds a single attribute name to delete.
  ///
  /// Parameters:
  /// - [name]: The attribute name (e.g., "custom:deliverables", "nickname")
  ///
  /// Returns the builder for method chaining.
  ///
  /// Throws:
  /// - [CognitoValidationException] if name is empty
  CognitoAdminDeleteUserAttributesBuilder attribute(String name) {
    final n = name.trim();
    if (n.isEmpty) {
      throw CognitoValidationException('Attribute name must be non-empty.');
    }
    _attributeNames.add(n);
    return this;
  }

  /// Adds multiple attribute names in one operation.
  ///
  /// Parameters:
  /// - [names]: Iterable of attribute names to add
  ///
  /// Returns the builder for method chaining.
  CognitoAdminDeleteUserAttributesBuilder attributes(Iterable<String> names) {
    for (final n in names) {
      attribute(n);
    }
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
  /// - Configured [CognitoAdminDeleteUserAttributesRequest]
  ///
  /// Throws:
  /// - [CognitoValidationException] if required fields are missing or invalid
  CognitoAdminDeleteUserAttributesRequest build({
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
    if (_attributeNames.isEmpty) {
      throw CognitoValidationException(
        'At least one attribute name is required.',
      );
    }

    return CognitoAdminDeleteUserAttributesRequest(
      userPoolId: up,
      username: un,
      userAttributeNames: List.unmodifiable(_attributeNames),
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer-style facade for AdminDeleteUserAttributes operation.
///
/// Provides a higher-level interface for building and executing attribute
/// deletion requests using the builder pattern.
class CognitoAdminDeleteUserAttributesConsumer {
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
  CognitoAdminDeleteUserAttributesConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to delete user attributes.
  ///
  /// Steps:
  /// 1. Invokes the [consumer] callback to populate the builder
  /// 2. Validates and builds the request
  /// 3. Executes the request with retries
  ///
  /// Parameters:
  /// - [consumer]: Callback that defines the request using the builder
  ///
  /// Returns:
  /// - [CognitoAdminDeleteUserAttributesResult] on success
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [ CognitoServiceException] for API failures
  Future<CognitoAdminDeleteUserAttributesResult> run(
    CognitoDeleteUserAttrsConsumerFn consumer,
  ) async {
    final b = CognitoAdminDeleteUserAttributesBuilder();
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
