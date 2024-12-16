import 'package:cognito_dart_auth_sdk/src/exceptions.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/user.dart';

/// Service to reload the user's information from cognito based on their ID token.
///
/// This class fetches the user's data from cognito again using the current ID token. This is useful
/// when you want to refresh the user's information after changes (like updating the email, password, etc.).
class ReloadUser {
  /// [auth] The instance of cognitoAuth used to perform authentication actions.
  final cognitoAuth auth;

  /// Constructor to initialize the [ReloadUser] service.
  ReloadUser({required this.auth});

  /// Reloads the user's data using their ID token from cognito.
  ///
  /// This method takes the user's [idToken] (obtained during sign-in or other authentication processes),
  /// performs a request to cognito to reload the user's information, and updates the current user's
  /// details in the app's authentication state.
  ///
  /// Parameters:
  /// - [idToken]: The cognito ID token of the authenticated user.
  ///
  /// Returns:
  /// - A [Future] that resolves to a [User] object containing the reloaded user information.
  ///
  /// Throws:
  /// - [cognitoAuthException] if the reload request fails or if the [idToken] is invalid or null.
  Future<User> reloadUser(String? idToken) async {
    try {
      // Validate that the idToken is not null
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to cognito to reload the user's data using the provided idToken
      final response = await auth.performRequest(
        'lookup', // Endpoint to lookup/reload user data
        {
          "idToken": idToken, // The current user's cognito ID token
        },
      );

      // Extract the user data from the response and create a User object
      User user = User.fromJson((response.body['users'] as List)[0]);

      // Update the current user in the cognitoAuth instance
      auth.updateCurrentUser(user);

      // Return the reloaded user object
      return user;
    } catch (e) {
      // Handle any errors that occur during the reload process
      print('Reload user action failed: $e');
      throw cognitoAuthException(
        code: 'reload-user',
        message: 'Failed to reload user information',
      );
    }
  }
}
