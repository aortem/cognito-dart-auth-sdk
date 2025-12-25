// -----------------------------
// Attribute Data Types
// -----------------------------

/// Enumerates the supported data types for Cognito user attributes.
///
/// These types correspond to the attribute data types supported by Amazon Cognito:
/// - String: Text values (e.g., names, addresses)
/// - Number: Numeric values (e.g., age, counts)
/// - DateTime: Date and time values (ISO 8601 format recommended)
/// - Boolean: True/false values
///
/// Example:
/// ```dart
/// final attributeType =    CognitoAttributeDataType.string;
/// print(attributeType.wire); // 'String'
/// ```
enum CognitoAttributeDataType {
  /// Textual data type for string values
  string,

  /// Numeric data type for integer or decimal values
  number,

  /// Date/time data type for temporal values
  datetime,

  /// Boolean data type for true/false values
  boolean,
}

/// Extension providing serialization of [CognitoAttributeDataType] to wire format.
///
/// Converts the enum values to their string representations as expected by
/// the Cognito API. This is used internally when sending requests to AWS.
extension _AttributeDataTypeWire on CognitoAttributeDataType {
  /// Returns the string representation of the attribute data type
  /// as expected by the Cognito API.
  ///
  /// Returns:
  /// - 'String' for [CognitoAttributeDataType.string]
  /// - 'Number' for [CognitoAttributeDataType.number]
  /// - 'DateTime' for [CognitoAttributeDataType.datetime]
  /// - 'Boolean' for [CognitoAttributeDataType.boolean]
  String get wire {
    switch (this) {
      case CognitoAttributeDataType.string:
        return 'String';
      case CognitoAttributeDataType.number:
        return 'Number';
      case CognitoAttributeDataType.datetime:
        return 'DateTime';
      case CognitoAttributeDataType.boolean:
        return 'Boolean';
    }
  }
}
