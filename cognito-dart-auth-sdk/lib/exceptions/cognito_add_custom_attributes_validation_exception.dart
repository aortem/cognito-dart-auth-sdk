class CognitoAttributeValidationException implements Exception {
  final String message;
  CognitoAttributeValidationException.CognitoAttributeValidationException(
    this.message,
  );
  @override
  String toString() => 'AttributeValidationException: $message';
}
