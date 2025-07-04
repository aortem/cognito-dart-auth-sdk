/// Exception thrown when the consumer fails to define valid attributes.
class AortemCognitoConsumerException implements Exception {
  final String message;
  AortemCognitoConsumerException(this.message);
  @override
  String toString() => 'ConsumerException: $message';
}
