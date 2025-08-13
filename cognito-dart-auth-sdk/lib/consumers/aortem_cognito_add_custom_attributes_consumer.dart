// cognito_add_custom_attributes_consumer.dart
//
// "Consumer"/builder-style API for AddCustomAttributes.
// Lets developers compose attributes at runtime using a fluent builder,
// then reuses the ticket #1 request class to call Cognito.
//
// Depends on types from: cognito_add_custom_attributes_request.dart

import 'package:cognito_dart_auth_sdk/enums/cognito_attribute_datatype.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_add_custom_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// A functional interface that allows callers to define Cognito attributes
/// using a fluent builder pattern at runtime.
///
/// Used with [AortemCognitoAddCustomAttributesConsumer.run] to dynamically
/// build attribute definitions before sending them to Cognito.
typedef AortemCognitoAttributesConsumer =
    void Function(AortemCognitoAttributeBuilder b);

/// Fluent builder for defining Cognito User Pool custom attributes.
///
/// Provides a chainable interface for constructing attribute definitions with:
/// - Type-specific convenience methods (string, number, boolean, datetime)
/// - A generic attribute method for full control
/// - Automatic name normalization (adding 'custom:' or 'dev:' prefixes)
/// - Built-in validation
class AortemCognitoAttributeBuilder {
  final List<AortemCognitoSchemaAttributeType> _items = [];

  /// Adds a generic attribute with full control over all parameters.
  ///
  /// Parameters:
  /// - [name]: Attribute name (will be normalized with 'custom:' or 'dev:' prefix)
  /// - [type]: The attribute data type
  /// - [developerOnly]: If true, uses 'dev:' prefix instead of 'custom:'
  /// - [mutable]: Whether the attribute can be changed after creation
  /// - [required]: Whether the attribute is required
  /// - [stringConstraints]: For string-type attributes only
  /// - [numberConstraints]: For number-type attributes only
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAttributeBuilder attribute({
    required String name,
    required AortemCognitoAttributeDataType type,
    bool developerOnly = false,
    bool mutable = true,
    bool required = false,
    AortemCognitoStringAttributeConstraints? stringConstraints,
    AortemCognitoNumberAttributeConstraints? numberConstraints,
  }) {
    final normalized = _normalizeName(name, developerOnly: developerOnly);
    _items.add(
      AortemCognitoSchemaAttributeType(
        name: normalized,
        attributeDataType: type,
        developerOnlyAttribute: developerOnly,
        mutable: mutable,

        stringAttributeConstraints: stringConstraints,
        numberAttributeConstraints: numberConstraints,
      ),
    );
    return this;
  }

  /// Convenience method for adding a string-type attribute.
  ///
  /// Parameters:
  /// - [name]: Attribute name
  /// - [developerOnly]: If true, marks as developer-only attribute
  /// - [mutable]: Whether the attribute can be changed after creation
  /// - [required]: Whether the attribute is required
  /// - [minLength]: Minimum length constraint (as string)
  /// - [maxLength]: Maximum length constraint (as string)
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAttributeBuilder string({
    required String name,
    bool developerOnly = false,
    bool mutable = true,
    bool required = false,
    String? minLength,
    String? maxLength,
  }) {
    return attribute(
      name: name,
      type: AortemCognitoAttributeDataType.string,
      developerOnly: developerOnly,
      mutable: mutable,
      required: required,
      stringConstraints: (minLength != null || maxLength != null)
          ? AortemCognitoStringAttributeConstraints(
              minLength: minLength,
              maxLength: maxLength,
            )
          : null,
    );
  }

  /// Convenience method for adding a number-type attribute.
  ///
  /// Parameters:
  /// - [name]: Attribute name
  /// - [developerOnly]: If true, marks as developer-only attribute
  /// - [mutable]: Whether the attribute can be changed after creation
  /// - [required]: Whether the attribute is required
  /// - [minValue]: Minimum value constraint (as string)
  /// - [maxValue]: Maximum value constraint (as string)
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAttributeBuilder number({
    required String name,
    bool developerOnly = false,
    bool mutable = true,
    bool required = false,
    String? minValue,
    String? maxValue,
  }) {
    return attribute(
      name: name,
      type: AortemCognitoAttributeDataType.number,
      developerOnly: developerOnly,
      mutable: mutable,
      required: required,
      numberConstraints: (minValue != null || maxValue != null)
          ? AortemCognitoNumberAttributeConstraints(
              minValue: minValue,
              maxValue: maxValue,
            )
          : null,
    );
  }

  /// Convenience method for adding a boolean-type attribute.
  ///
  /// Parameters:
  /// - [name]: Attribute name
  /// - [developerOnly]: If true, marks as developer-only attribute
  /// - [mutable]: Whether the attribute can be changed after creation
  /// - [required]: Whether the attribute is required
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAttributeBuilder boolean({
    required String name,
    bool developerOnly = false,
    bool mutable = true,
    bool required = false,
  }) {
    return attribute(
      name: name,
      type: AortemCognitoAttributeDataType.boolean,
      developerOnly: developerOnly,
      mutable: mutable,
      required: required,
    );
  }

  /// Convenience method for adding a datetime-type attribute.
  ///
  /// Parameters:
  /// - [name]: Attribute name
  /// - [developerOnly]: If true, marks as developer-only attribute
  /// - [mutable]: Whether the attribute can be changed after creation
  /// - [required]: Whether the attribute is required
  ///
  /// Returns the builder for method chaining.
  AortemCognitoAttributeBuilder dateTime({
    required String name,
    bool developerOnly = false,
    bool mutable = true,
    bool required = false,
  }) {
    return attribute(
      name: name,
      type: AortemCognitoAttributeDataType.datetime,
      developerOnly: developerOnly,
      mutable: mutable,
      required: required,
    );
  }

  /// Builds the final list of attribute definitions.
  ///
  /// Returns an unmodifiable list of [AortemCognitoSchemaAttributeType].
  List<AortemCognitoSchemaAttributeType> build() => List.unmodifiable(_items);

  /// Normalizes attribute names by ensuring proper prefixes.
  ///
  /// Rules:
  /// - For developer-only attributes: ensures 'dev:' prefix
  /// - For regular attributes: ensures 'custom:' prefix
  /// - Validates name format
  ///
  /// Throws [AortemCognitoValidationException] for invalid names.
  String _normalizeName(String raw, {required bool developerOnly}) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw AortemCognitoValidationException('Attribute name cannot be empty.');
    }
    if (developerOnly) {
      if (trimmed.startsWith('dev:')) return trimmed;
      if (trimmed.startsWith('custom:')) {
        throw AortemCognitoValidationException(
          'Developer-only attributes must use the "dev:" prefix.',
        );
      }
      return 'dev:$trimmed';
    } else {
      if (trimmed.startsWith('custom:') || trimmed.startsWith('dev:')) {
        return trimmed;
      }
      return 'custom:$trimmed';
    }
  }
}

/// Provides a consumer-style API for adding custom attributes to Cognito.
///
/// This class wraps the lower-level request API with a more fluent interface
/// that allows dynamic attribute definition at runtime.
class AortemCognitoAddCustomAttributesConsumer {
  /// The Cognito User Pool ID to add attributes to.
  final String userPoolId;

  /// The AWS region where the User Pool exists.
  final String region;

  /// The HTTP client for making requests.
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures.
  /// Defaults to 2 (total attempts = initial + 2 retries = 3 attempts).
  final int maxRetries;

  /// Timeout for each request attempt.
  /// Defaults to 20 seconds.
  final Duration requestTimeout;

  /// Creates a consumer instance.
  ///
  /// Required parameters:
  /// - [userPoolId]: The Cognito User Pool ID
  /// - [region]: The AWS region
  /// - [httpClient]: The HTTP client implementation
  ///
  /// Optional parameters:
  /// - [maxRetries]: Number of retry attempts (default 2)
  /// - [requestTimeout]: Timeout per attempt (default 20 seconds)
  AortemCognitoAddCustomAttributesConsumer({
    required this.userPoolId,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the consumer flow to add custom attributes.
  ///
  /// Steps:
  /// 1. Invokes the [consumer] callback to build attribute definitions
  /// 2. Validates the resulting attributes
  /// 3. Creates and executes an AddCustomAttributes request
  ///
  /// Parameters:
  /// - [consumer]: Callback that defines attributes using the builder
  ///
  /// Returns a Future that completes with the operation result.
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid input
  /// - [AortemCognitoServiceException] for API failures
  Future<AortemCognitoAddCustomAttributesResult> run(
    AortemCognitoAttributesConsumer consumer,
  ) async {
    if (userPoolId.trim().isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }

    final builder = AortemCognitoAttributeBuilder();
    consumer(builder);
    final attrs = builder.build();

    if (attrs.isEmpty) {
      throw AortemCognitoValidationException(
        'At least one attribute must be defined.',
      );
    }
    if (attrs.length > 25) {
      throw AortemCognitoValidationException(
        'You can add a maximum of 25 attributes per request.',
      );
    }

    final req = AortemCognitoAddCustomAttributesRequest(
      userPoolId: userPoolId,
      region: region,
      httpClient: httpClient,
      customAttributes: attrs,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }
}
