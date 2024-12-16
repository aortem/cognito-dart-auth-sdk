import 'package:cognito_dart_auth_sdk/src/exceptions.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/user.dart';

/// Service to unlink a provider from a cognito user.
///
/// This class handles the process of unlinking a specific provider (such as Google, Facebook, etc.)
/// from a cognito user account.
class UnlinkProvider {
  /// [auth] The instance of cognitoAuth used to perform authentication actions.
  final cognitoAuth auth;

  /// Constructor to initialize the [UnlinkProvider] service.
  UnlinkProvider({required this.auth});

  /// Unlinks a provider from the user account.
  ///
  /// This method takes the user's [idToken] (obtained during sign-in) and the [providerId]
  /// (the ID of the provider to unlink) and makes a request to cognito to unlink the provider.
  ///
  /// Parameters:
  /// - [idToken]: The cognito ID token of the user. It is required to verify the user's identity.
  /// - [providerId]: The ID of the provider to unlink (e.g., 'google.com', 'facebook.com').
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after unlinking the provider.
  ///
  /// Throws:
  /// - [cognitoAuthException] if the request to unlink the provider fails.
  Future<User> unlinkProvider(String? idToken, String providerId) async {
    try {
      // Validate the parameters: ensure idToken is not null,
      // providerId is not empty, and the user is signed in.
      assert(idToken != null, 'Id token cannot be null');
      assert(providerId.isNotEmpty, 'ProviderId cannot be an empty string');
      assert(auth.currentUser != null, 'User not signed in');

      // Perform the request to cognito to unlink the provider
      final response = await auth.performRequest(
        'update', // cognito endpoint to update user info
        {
          "idToken": idToken, // The cognito ID token of the user
          "deleteProvider": [providerId], // List of providers to unlink
        },
      );

      // Parse the response to get the updated user object
      User user = User.fromJson(response.body);

      // Update the current user in the authentication system
      auth.updateCurrentUser(user);

      // Return the updated user object
      return user;
    } catch (e) {
      // Handle errors during the request
      print('Unlink provider action failed: $e');
      throw cognitoAuthException(
        code: 'unlink-provider', // Custom error code for this action
        message: 'Failed to unlink provider', // Error message
      );
    }
  }
}
