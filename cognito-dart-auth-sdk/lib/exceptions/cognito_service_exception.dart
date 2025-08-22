/// An exception thrown when an error occurs while interacting with AWS Cognito services.
///
/// This exception represents service-level errors that occur during Cognito API operations,
/// including HTTP errors, authentication failures, and other AWS service responses.
///
/// The exception captures:
/// - A human-readable error message
/// - The HTTP status code (if available)
/// - The raw response body (if available) for debugging purposes
///
/// Example Usage:
/// ```dart
/// try {
///   await cognitoClient.makeRequest();
/// } on CognitoServiceException catch (e) {
///   if (e.statusCode != null) {
///     print('Cognito error (${e.statusCode}): ${e.message}');
///   } else {
///     print('Cognito error: ${e.message}');
///   }
///
///   if (e.responseBody != null) {
///     print('Response details: ${e.responseBody}');
///   }
/// }
/// ```
class CognitoServiceException implements Exception {
  /// A human-readable description of the error that occurred.
  final String message;

  /// The HTTP status code returned by the AWS Cognito service, if available.
  ///
  /// Common status codes include:
  /// - 400 (Bad Request)
  /// - 401 (Unauthorized)
  /// - 403 (Forbidden)
  /// - 404 (Not Found)
  /// - 500 (Internal Server Error)
  final int? statusCode;

  /// The raw response body from the Cognito service, if available.
  ///
  /// This may contain additional error details in JSON format. The structure varies
  /// depending on the specific API call and error type.
  final Map<String, dynamic>? responseBody;

  /// Creates a new service exception instance.
  ///
  /// Parameters:
  /// - [message]: Required description of the error
  /// - [statusCode]: Optional HTTP status code from the failed request
  /// - [responseBody]: Optional raw response data for debugging
  CognitoServiceException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() => statusCode != null
      ? 'CognitoServiceException($statusCode): $message'
      : 'CognitoServiceException: $message';
}
