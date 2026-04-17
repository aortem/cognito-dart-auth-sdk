// -----------------------------
// Exceptions
// -----------------------------

/// Thrown when one or more parameters provided to an   Cognito
/// request are invalid or fail pre-validation checks.
///
/// This exception is used to prevent sending malformed requests to
/// AWS Cognito by catching invalid input early (before any network call).
///
/// ## Typical Causes:
/// - Missing required parameters (e.g., `userPoolId`, `username`, etc.).
/// - Values not matching Cognito's documented patterns.
/// - Attribute values that exceed AWS size limits.
///
/// ## Fields:
/// - [message]: A human-readable description of the validation failure.
/// - [cause]: An optional underlying cause (e.g., another exception or
///   low-level error object).
///
/// ## Example:
/// ```dart
/// if (userPoolId.isEmpty) {
///   throw  CognitoValidationException(
///     'userPoolId is required.',
///   );
/// }
/// ```
///
/// This exception should generally be caught at the boundary where
/// requests are constructed, allowing developers to correct input
/// before retrying.
class CognitoValidationException implements Exception {
  /// A description of why the validation failed.
  final String message;

  /// An optional underlying cause for the failure.
  final Object? cause;

  ///
  CognitoValidationException(this.message, {this.cause});

  @override
  String toString() => 'CognitoValidationException: $message';
}
