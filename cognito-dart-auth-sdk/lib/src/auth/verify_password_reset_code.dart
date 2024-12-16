import 'dart:developer';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
import 'package:cognito_dart_auth_sdk/src/http_response.dart';

/// A service to verify a password reset code in cognito Authentication.
///
/// This service validates a password reset code that was previously sent to the user via email.
/// If the code is valid, it confirms that the user can proceed with resetting their password.
class VerifyPasswordResetCodeService {
  /// The [cognitoAuth] instance used to perform authentication actions.
  final cognitoAuth auth;

  /// Constructs an instance of [VerifyPasswordResetCodeService].
  ///
  /// Parameters:
  /// - [auth]: The [cognitoAuth] instance that handles authentication requests.
  VerifyPasswordResetCodeService({required this.auth});

  /// Verifies a password reset code sent to the user.
  ///
  /// This method checks if the given password reset code is valid by sending a request
  /// to cognito's Authentication service. If the code is valid, it allows the user to proceed
  /// with resetting their password.
  ///
  /// Parameters:
  /// - [code]: The password reset code received by the user (typically via email).
  ///
  /// Returns:
  /// - A [HttpResponse] object containing the server's response to the verification request.
  ///
  /// Throws:
  /// - [cognitoAuthException] if an error occurs during the verification process.
  Future<String?> verifyPasswordResetCode(String code) async {
    try {
      // The URL for cognito Authentication API to verify the password reset code.
      final url = 'resetPassword';

      // The body of the request containing the password reset code to be verified.
      final body = {
        'oobCode': code, // The out-of-band (OOB) code received by the user.
      };

      // Perform the request to cognito Authentication service.
      final response = await auth.performRequest(url, body);

      // Log the response for debugging if the password reset code is valid.
      if (response.statusCode == 200) {
        log("Password reset code verification successful: $response");
      }

      // Return the response from the server.
      return "Response is $response";
    } catch (e) {
      // Print the error message if an exception occurs during the verification process.
      print('Verify password reset code failed: $e');

      // Throw a cognitoAuthException if the verification fails.
      throw cognitoAuthException(
        code:
            'verify-password-reset-code-error', // Error code for this operation.
        message:
            'Failed to verify password reset code.', // Error message for the exception.
      );
    }
  }
}
