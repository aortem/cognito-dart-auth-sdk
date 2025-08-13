// aortem_cognito_add_custom_attributes_request.dart
// SDK: Aortem Cognito (Dart)
// Ticket: AortemCognitoAddCustomAttributesRequest — Add Custom Attributes to Cognito User Pool
// Naming: aortem_cognito_<filename>.dart (per convention)
//
// This file implements the AddCustomAttributes API operation for Amazon Cognito,
// allowing administrators to add custom attributes to a user pool schema.

import 'dart:async';
import 'dart:convert';

import 'package:cognito_dart_auth_sdk/enums/aortem_cognito_attribute_datatype.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

// -----------------------------
// Constraints Models
// -----------------------------

/// Represents constraints for string-type custom attributes in Cognito.
///
/// These constraints define minimum and maximum length requirements for
/// string attributes. Note that Cognito expects these values as strings
/// in the API payload (e.g., "1" instead of 1).
class AortemCognitoStringAttributeConstraints {
  /// Minimum allowed length as a string (e.g., "1")
  final String? minLength;

  /// Maximum allowed length as a string (e.g., "2048")
  final String? maxLength;

  /// Creates a new StringAttributeConstraints instance
  const AortemCognitoStringAttributeConstraints({
    this.minLength,
    this.maxLength,
  });

  /// Validates the constraints
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - minLength or maxLength are not valid integer strings
  /// - minLength is negative
  /// - minLength > maxLength
  void validate() {
    int? min = minLength == null ? null : int.tryParse(minLength!);
    int? max = maxLength == null ? null : int.tryParse(maxLength!);
    if (minLength != null && min == null) {
      throw AortemCognitoValidationException(
        'StringAttributeConstraints.minLength must be an integer string.',
      );
    }
    if (maxLength != null && max == null) {
      throw AortemCognitoValidationException(
        'StringAttributeConstraints.maxLength must be an integer string.',
      );
    }
    if (min != null && min < 0) {
      throw AortemCognitoValidationException(
        'StringAttributeConstraints.minLength must be >= 0.',
      );
    }
    if (min != null && max != null && min > max) {
      throw AortemCognitoValidationException(
        'StringAttributeConstraints.minLength cannot be greater than maxLength.',
      );
    }
  }

  /// Converts the constraints to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      if (minLength != null) 'MinLength': minLength,
      if (maxLength != null) 'MaxLength': maxLength,
    };
  }
}

/// Represents constraints for number-type custom attributes in Cognito.
///
/// These constraints define minimum and maximum value requirements for
/// numeric attributes. Note that Cognito expects these values as strings
/// in the API payload (e.g., "0" instead of 0).
class AortemCognitoNumberAttributeConstraints {
  /// Minimum allowed value as a string (e.g., "0")
  final String? minValue;

  /// Maximum allowed value as a string (e.g., "999")
  final String? maxValue;

  /// Creates a new NumberAttributeConstraints instance
  const AortemCognitoNumberAttributeConstraints({this.minValue, this.maxValue});

  /// Validates the constraints
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - minValue or maxValue are not valid numeric strings
  /// - minValue > maxValue
  void validate() {
    double? min = minValue == null ? null : double.tryParse(minValue!);
    double? max = maxValue == null ? null : double.tryParse(maxValue!);
    if (minValue != null && min == null) {
      throw AortemCognitoValidationException(
        'NumberAttributeConstraints.minValue must be a numeric string.',
      );
    }
    if (maxValue != null && max == null) {
      throw AortemCognitoValidationException(
        'NumberAttributeConstraints.maxValue must be a numeric string.',
      );
    }
    if (min != null && max != null && min > max) {
      throw AortemCognitoValidationException(
        'NumberAttributeConstraints.minValue cannot be greater than maxValue.',
      );
    }
  }

  /// Converts the constraints to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      if (minValue != null) 'MinValue': minValue,
      if (maxValue != null) 'MaxValue': maxValue,
    };
  }
}

// -----------------------------
// Schema Attribute Model (subset as required by AddCustomAttributes)
// -----------------------------

/// Represents a custom attribute schema definition for Cognito user pools.
///
/// This model represents the subset of schema attributes needed for the
/// AddCustomAttributes API operation.
class AortemCognitoSchemaAttributeType {
  /// The name of the custom attribute (must start with 'custom:')
  final String name;

  /// The data type of the attribute
  final AortemCognitoAttributeDataType attributeDataType;

  /// Whether this attribute is only accessible by developers
  final bool? developerOnlyAttribute;

  /// Whether this attribute can be modified after creation
  final bool? mutable;

  /// String-specific constraints (only for String attributes)
  final AortemCognitoStringAttributeConstraints? stringAttributeConstraints;

  /// Number-specific constraints (only for Number attributes)
  final AortemCognitoNumberAttributeConstraints? numberAttributeConstraints;

  /// Creates a new SchemaAttributeType instance
  AortemCognitoSchemaAttributeType({
    required this.name,
    required this.attributeDataType,
    this.developerOnlyAttribute,
    this.mutable,
    this.stringAttributeConstraints,
    this.numberAttributeConstraints,
  });

  /// Validates the attribute definition
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - name is empty or doesn't match required pattern
  /// - constraints are provided for unsupported data types
  /// - constraints are invalid
  void validate() {
    // Required
    if (name.trim().isEmpty) {
      throw AortemCognitoValidationException('Attribute Name is required.');
    }

    // Name must be 'custom:<alnum_or_underscore>'
    final namePattern = RegExp(r'^custom:[A-Za-z0-9_]+$');
    if (!namePattern.hasMatch(name)) {
      throw AortemCognitoValidationException(
        "Invalid attribute Name '$name'. It must match ^custom:[A-Za-z0-9_]+",
      );
    }

    // Constraints allowed only for String/Number
    if (attributeDataType == AortemCognitoAttributeDataType.string) {
      numberAttributeConstraints?.validate();
      stringAttributeConstraints?.validate();
      if (numberAttributeConstraints != null) {
        throw AortemCognitoValidationException(
          'NumberAttributeConstraints provided for a String attribute.',
        );
      }
    } else if (attributeDataType == AortemCognitoAttributeDataType.number) {
      stringAttributeConstraints?.validate();
      numberAttributeConstraints?.validate();
      if (stringAttributeConstraints != null) {
        throw AortemCognitoValidationException(
          'StringAttributeConstraints provided for a Number attribute.',
        );
      }
    } else {
      if (stringAttributeConstraints != null ||
          numberAttributeConstraints != null) {
        throw AortemCognitoValidationException(
          'Constraints are only supported for String or Number attribute types.',
        );
      }
    }
  }

  /// Converts the attribute to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'AttributeDataType': _mapAttributeDataType(attributeDataType),
      if (developerOnlyAttribute != null)
        'DeveloperOnlyAttribute': developerOnlyAttribute,
      if (mutable != null) 'Mutable': mutable,
      if (stringAttributeConstraints != null)
        'StringAttributeConstraints': stringAttributeConstraints!.toJson(),
      if (numberAttributeConstraints != null)
        'NumberAttributeConstraints': numberAttributeConstraints!.toJson(),
    };
  }

  /// Maps the Dart enum to AWS API string values
  static String _mapAttributeDataType(AortemCognitoAttributeDataType t) {
    switch (t) {
      case AortemCognitoAttributeDataType.string:
        return 'String';
      case AortemCognitoAttributeDataType.number:
        return 'Number';
      case AortemCognitoAttributeDataType.boolean:
        return 'Boolean';
      case AortemCognitoAttributeDataType.datetime:
        return 'DateTime';
    }
  }
}

// -----------------------------
// Request & Result Models
// -----------------------------

/// Represents the successful result of adding custom attributes.
///
/// This is essentially a marker class since the operation returns no data
/// on success (200 OK with empty body).
class AortemCognitoAddCustomAttributesResult {
  /// Creates a new result instance
  AortemCognitoAddCustomAttributesResult();

  /// Creates a result from an HTTP response
  factory AortemCognitoAddCustomAttributesResult.fromHttp(
    AortemCognitoHttpResponse resp,
  ) {
    // Cognito returns {} on success
    return AortemCognitoAddCustomAttributesResult();
  }
}

/// Request wrapper for the AddCustomAttributes API operation.
///
/// This class handles:
/// - Request construction
/// - Parameter validation
/// - Execution with retries
/// - Error handling
class AortemCognitoAddCustomAttributesRequest {
  /// The ID of the user pool to add attributes to
  final String userPoolId;

  /// The list of custom attributes to add
  final List<AortemCognitoSchemaAttributeType> customAttributes;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum number of retry attempts (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new request instance
  AortemCognitoAddCustomAttributesRequest({
    required this.userPoolId,
    required this.customAttributes,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  // -------- Validation --------

  /// Validates the request parameters
  ///
  /// Throws [AortemCognitoValidationException] if:
  /// - userPoolId is empty
  /// - customAttributes list is empty
  /// - any attribute fails validation
  void validate() {
    if (userPoolId.trim().isEmpty) {
      throw AortemCognitoValidationException('UserPoolId is required.');
    }
    if (customAttributes.isEmpty) {
      throw AortemCognitoValidationException(
        'At least one custom attribute is required.',
      );
    }
    for (final attr in customAttributes) {
      attr.validate();
    }
  }

  // -------- Payload Builder --------

  /// Builds the API request payload
  Map<String, dynamic> buildPayload() {
    return {
      'UserPoolId': userPoolId,
      'CustomAttributes': customAttributes.map((a) => a.toJson()).toList(),
    };
  }

  // -------- Executor --------

  /// Executes the AddCustomAttributes API request
  ///
  /// Returns:
  /// - [AortemCognitoAddCustomAttributesResult] on success
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] if parameters are invalid
  /// - [AortemCognitoServiceException] if the API call fails
  Future<AortemCognitoAddCustomAttributesResult> execute() async {
    validate();

    const target = 'AWSCognitoIdentityProviderService.AddCustomAttributes';
    final payload = buildPayload();

    int attempt = 0;
    while (true) {
      try {
        final resp = await httpClient.post(
          region: region,
          xAmzTarget: target,
          payload: payload,
          additionalHeaders: const {
            'Content-Type': 'application/x-amz-json-1.1',
          },
          timeout: requestTimeout,
        );

        // Success: 200
        if (resp.statusCode == 200) {
          return AortemCognitoAddCustomAttributesResult.fromHttp(resp);
        }

        // Handle retryable errors (5xx, throttling)
        final body = resp.jsonBody;
        final code = _extractErrorCode(resp.headers, body);
        final isRetryable = _isRetryable(resp.statusCode, code);

        if (isRetryable && attempt < maxRetries) {
          await _sleepBackoff(attempt);
          attempt++;
          continue;
        }

        // Not retryable or out of attempts — throw (message first)
        throw AortemCognitoServiceException(
          code ?? 'ServiceError',
          statusCode: resp.statusCode,
          responseBody: body,
        );
      } catch (e) {
        // Network/timeout or other errors: retry if allowed
        if (e is AortemCognitoServiceException) rethrow;
        if (attempt < maxRetries) {
          await _sleepBackoff(attempt);
          attempt++;
          continue;
        }
        throw AortemCognitoServiceException(
          'NetworkError: ${e.toString()}',
          statusCode: 599,
        );
      }
    }
  }

  // -------- Helpers --------

  /// Extracts the error code from response headers or body
  static String? _extractErrorCode(
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    // Cognito may return error type in headers or JSON body {"__type":"...","message":"..."}
    final headerType =
        headers['x-amzn-ErrorType'] ?? headers['X-Amzn-ErrorType'];
    if (headerType != null) {
      return headerType.split(':').first;
    }
    final type = body == null ? null : (body['__type'] as String?);
    if (type != null) return type.split('#').last;
    final code = body == null ? null : (body['code'] as String?);
    return code;
  }

  /// Determines if an error is retryable based on status code and error code
  static bool _isRetryable(int statusCode, String? errorCode) {
    if (statusCode >= 500) return true; // 5xx
    if (statusCode == 429) return true; // throttling via status code
    const throttles = {
      'TooManyRequestsException',
      'LimitExceededException',
      'ThrottlingException',
      'RequestTimeout',
      'RequestTimeoutException',
      'InternalErrorException',
      'ServiceUnavailable',
    };
    return throttles.contains(errorCode);
  }

  /// Implements exponential backoff with jitter
  static Future<void> _sleepBackoff(int attempt) async {
    // Exponential backoff with jitter: base 200ms * 2^attempt + [0..200)ms
    final base = 200 * (1 << attempt);
    final jitter = DateTime.now().microsecondsSinceEpoch % 200;
    await Future<void>.delayed(Duration(milliseconds: base + jitter));
  }
}

// -----------------------------
// Example SigV4 client sketch (provide real implementation in your SDK)
// -----------------------------

/// A minimal sketch showing how an HTTP client could be implemented.
/// Replace with your SDK's shared HTTP + SigV4 machinery.
class AortemCognitoSigV4HttpClient implements AortemCognitoHttpClient {
  final Future<AortemCognitoHttpResponse> Function({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
    Duration? timeout,
  })
  _sender;

  final Future<Map<String, String>> Function({
    required String region,
    required String service,
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  })
  _signer;

  /// Creates a new SigV4 HTTP client with the given sender and signer functions
  AortemCognitoSigV4HttpClient(this._sender, this._signer);

  @override
  Future<AortemCognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) async {
    final uri = Uri.https('cognito-idp.$region.amazonaws.com', '/');

    final baseHeaders = <String, String>{
      'Host': uri.host,
      'X-Amz-Target': xAmzTarget,
      'Content-Type': 'application/x-amz-json-1.1',
    };
    if (additionalHeaders != null) {
      baseHeaders.addAll(additionalHeaders);
    }

    final body = json.encode(payload);

    final signedHeaders = await _signer(
      region: region,
      service: 'cognito-idp',
      method: 'POST',
      uri: uri,
      headers: baseHeaders,
      body: body,
    );

    final finalHeaders = {...baseHeaders, ...signedHeaders};

    return await _sender(
      uri: uri,
      headers: finalHeaders,
      body: body,
      timeout: timeout,
    );
  }

  /// Bridge for request classes that call `send(...)`
  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) {
    // `service` is ignored here since this client is Cognito-specific.
    return post(
      region: region,
      xAmzTarget: target,
      payload: payload,
      additionalHeaders: headers,
      timeout: timeout,
    );
  }
}
