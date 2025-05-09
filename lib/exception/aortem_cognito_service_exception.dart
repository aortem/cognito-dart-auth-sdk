/// Exception thrown when attribute input validation fails.

/// Exception thrown for errors returned by the Cognito service.
class AortemCognitoServiceException implements Exception {
  final String message;
  AortemCognitoServiceException(this.message);
  @override
  String toString() => 'CognitoServiceException: $message';
}

