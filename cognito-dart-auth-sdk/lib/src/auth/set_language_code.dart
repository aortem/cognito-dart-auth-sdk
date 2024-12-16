import 'package:cognito_dart_auth_sdk/src/exceptions.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/user.dart';

/// Service to set the language code for a cognito user.
///
/// This class allows you to set or update the preferred language code
/// for a user in cognito Authentication. This language code is used
/// by cognito for communication and localization purposes.
class SetLanguageCode {
  /// The instance of [cognitoAuth] used to perform authentication actions.
  final cognitoAuth auth;

  /// Constructor to initialize the [SetLanguageCode] service.
  ///
  /// Parameters:
  /// - [auth]: The [cognitoAuth] instance used for user authentication and operations.
  SetLanguageCode({required this.auth});

  /// Sets the language code for the user.
  ///
  /// This method updates the preferred language code for the user in cognito Authentication.
  /// It takes the user's [idToken] (which proves their identity) and the [languageCode]
  /// (representing the preferred language, e.g., 'en' for English, 'es' for Spanish).
  ///
  /// Parameters:
  /// - [idToken]: The cognito ID token of the user. It is required to verify the user's identity.
  /// - [languageCode]: A string representing the language code (e.g., 'en' for English, 'es' for Spanish).
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after setting the language code.
  ///
  /// Throws:
  /// - [cognitoAuthException] if the request to set the language code fails.
  Future<User> setLanguageCode(String? idToken, String languageCode) async {
    try {
      // Step 1: Validate the parameters. Ensure the idToken is not null and languageCode is not empty.
      assert(idToken != null, 'Id token cannot be null');
      assert(languageCode.isNotEmpty, 'Language code cannot be empty');

      // Step 2: Perform the request to cognito to update the language code for the user
      final response = await auth.performRequest(
        'update', // cognito endpoint for updating user details
        {
          "idToken": idToken, // The cognito ID token of the user
          "languageCode": languageCode, // The new language code to be set
        },
      );

      // Step 3: Parse the response to get the updated user object
      User user = User.fromJson(response.body);

      // Step 4: Update the current user with the new language code setting
      auth.updateCurrentUser(user);

      // Step 5: Return the updated user object
      return user;
    } catch (e) {
      // Handle any errors during the request
      print('Set language code action failed: $e');
      throw cognitoAuthException(
        code: 'set-language-code', // Custom error code for this action
        message: 'Failed to set language code', // Error message
      );
    }
  }
}
