/// Exception for invalid or missing parameters.
class AortemCognitoAdminAddUserToGroupException implements Exception {
  final String message;
  AortemCognitoAdminAddUserToGroupException(this.message);

  @override
  String toString() => 'AdminAddUserToGroupException: $message';
}