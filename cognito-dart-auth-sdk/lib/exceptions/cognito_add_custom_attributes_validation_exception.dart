class CognitoAttributeValidationException implements Exception {
  /// Human-readable validation failure details.
  final String message;

  /// Creates a validation exception for malformed custom attribute definitions.
  CognitoAttributeValidationException(this.message);

  @override
  String toString() => 'AttributeValidationException: $message';
}
