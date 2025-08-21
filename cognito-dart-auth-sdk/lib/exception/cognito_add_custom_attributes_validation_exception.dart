class AortemCognitoAttributeValidationException implements Exception {
  final String message;
  AortemCognitoAttributeValidationException(this.message);
  @override
  String toString() => 'AttributeValidationException: $message';
}
