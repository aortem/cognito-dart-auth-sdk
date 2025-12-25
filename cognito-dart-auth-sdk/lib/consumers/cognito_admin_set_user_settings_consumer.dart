// Ticket #54 - Issue   CognitoAdminSetUserSettingsConsumer
// Handles response and errors for AdminSetUserSettings

/// [DEPRECATED] Response class for AdminSetUserSettings API operation.
///
/// ⚠️ This API action is deprecated by AWS Cognito.
/// Use [   CognitoAdminSetUserMFAPreferenceRequest] and corresponding
/// response classes instead for setting user MFA preferences.
///
/// This class handles the response from the deprecated AdminSetUserSettings API,
/// which returns an HTTP 200 status with an empty body on success.
///
/// The AdminSetUserSettings operation was used to set MFA preferences for users
/// but has been superseded by the AdminSetUserMFAPreference API.
class CognitoAdminSetUserSettingsResponse {
  /// Indicates whether the operation was successful.
  ///
  /// For the deprecated AdminSetUserSettings API, a successful response
  /// is indicated by an HTTP 200 status code with an empty response body.
  final bool success;

  /// Creates a new response instance for the deprecated AdminSetUserSettings API.
  ///
  /// Parameters:
  /// - [success]: Optional - Whether the operation was successful (default: true)
  ///
  /// Note: This API is deprecated. Consider using AdminSetUserMFAPreference instead.
  CognitoAdminSetUserSettingsResponse({this.success = true});

  /// Creates a response instance from JSON data.
  ///
  /// The AdminSetUserSettings API returns an empty response body on success,
  /// so this factory method primarily serves to handle the response gracefully.
  ///
  /// Parameters:
  /// - [json]: Optional JSON data (typically empty for this deprecated API)
  ///
  /// Returns:
  /// A new [   CognitoAdminSetUserSettingsResponse] instance with success=true
  ///
  /// Note: Part of deprecated API. Use newer MFA preference methods instead.
  factory CognitoAdminSetUserSettingsResponse.fromJson(
    Map<String, dynamic>? json,
  ) {
    // Even though the body is empty, we handle parsing gracefully.
    return CognitoAdminSetUserSettingsResponse(success: true);
  }
}

/// Exception representing an internal error in AWS Cognito service.
///
/// This exception is thrown when the AWS Cognito service encounters
/// an internal error while processing the AdminSetUserSettings request.
///
/// Typically indicates a temporary service issue that may be resolved by retrying.
class InternalErrorException implements Exception {
  /// Descriptive message about the internal error.
  final String message;

  /// Creates a new InternalErrorException.
  ///
  /// - [message]: Optional - Custom error message (default: "Internal error occurred in Cognito")
  InternalErrorException([this.message = "Internal error occurred in Cognito"]);
}

/// Exception representing invalid parameters in a Cognito request.
///
/// This exception is thrown when the AdminSetUserSettings request contains
/// invalid or malformed parameters that cannot be processed by the service.
///
/// Common causes include:
/// - Missing required parameters
/// - Invalid parameter formats
/// - Parameter values outside acceptable ranges
class InvalidParameterException implements Exception {
  /// Descriptive message about the invalid parameter.
  final String message;

  /// Creates a new InvalidParameterException.
  ///
  /// Parameters:
  /// - [message]: Optional - Custom error message (default: "Invalid parameter in Cognito request")
  InvalidParameterException([
    this.message = "Invalid parameter in Cognito request",
  ]);
}

/// Exception representing authorization failure for a Cognito operation.
///
/// This exception is thrown when the caller is not authorized to perform
/// the AdminSetUserSettings operation. This can occur due to:
/// - Insufficient IAM permissions
/// - Invalid credentials
/// - Lack of required scopes or policies
class NotAuthorizedException implements Exception {
  /// Descriptive message about the authorization failure.
  final String message;

  /// Creates a new NotAuthorizedException.
  ///
  /// Parameters:
  /// - [message]: Optional - Custom error message (default: "Not authorized")
  NotAuthorizedException([this.message = "Not authorized"]);
}

/// Exception representing a missing resource in AWS Cognito.
///
/// This exception is thrown when the AdminSetUserSettings operation
/// references a resource that does not exist, such as:
/// - Non-existent User Pool
/// - Deleted or unavailable resource
class ResourceNotFoundException implements Exception {
  /// Descriptive message about the missing resource.
  final String message;

  /// Creates a new ResourceNotFoundException.
  ///
  /// Parameters:
  /// - [message]: Optional - Custom error message (default: "Requested resource not found")
  ResourceNotFoundException([this.message = "Requested resource not found"]);
}

/// Exception representing a missing user in AWS Cognito.
///
/// This exception is thrown when the AdminSetUserSettings operation
/// references a user that does not exist in the specified User Pool.
///
/// Common causes include:
/// - Typographical errors in username
/// - User has been deleted
/// - User hasn't been created yet
class UserNotFoundException implements Exception {
  /// Descriptive message about the missing user.
  final String message;

  /// Creates a new UserNotFoundException.
  ///
  /// Parameters:
  /// - [message]: Optional - Custom error message (default: "User not found")
  UserNotFoundException([this.message = "User not found"]);
}
