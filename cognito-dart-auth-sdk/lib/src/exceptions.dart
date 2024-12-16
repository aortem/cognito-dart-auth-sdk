///expection
class cognitoAuthException implements Exception {
  ///code
  final String code;

  ///message
  final String message;

  ///auth expection

  cognitoAuthException({required this.code, required this.message});

  @override
  String toString() => 'cognitoAuthException: $code - $message';
}
