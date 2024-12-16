import 'package:cognito_dart_auth_sdk/src/exceptions.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/user.dart';

/// Service to update the user's profile information (display name and photo URL).
class UpdateProfile {
  /// [auth] The instance of cognitoAuth used to perform authentication actions.
  final cognitoAuth auth;

  /// Constructor to initialize the [UpdateProfile] service.
  UpdateProfile(this.auth);

  /// Updates the display name and photo URL for a cognito user.
  ///
  /// This method takes the user's [displayName], [displayImage] (photo URL), and [idToken]
  /// (obtained during sign-in) and makes a request to cognito to update the profile.
  ///
  /// Parameters:
  /// - [displayName]: The new display name to set for the user.
  /// - [displayImage]: The URL of the new photo to set for the user.
  /// - [idToken]: The cognito ID token of the user. It is required to verify the user's identity.
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after the profile update.
  ///
  /// Throws:
  /// - [cognitoAuthException] if the request to update the profile fails.
  Future<User> updateProfile(
    String displayName,
    String displayImage,
    String? idToken,
  ) async {
    try {
      // Validate the parameters: ensure idToken is not null.
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to cognito to update the user's profile.
      final response = await auth.performRequest(
        'update', // cognito endpoint to update user data.
        {
          "idToken": idToken, // The cognito ID token of the user.
          "displayName": displayName, // The new display name to set.
          "photoUrl": displayImage, // The new photo URL to set.
          "returnSecureToken": true // Return a secure token after the update.
        },
      );

      // Parse the response to get the updated user object.
      User user = User.fromJson(response.body);

      // Update the current user in the authentication system.
      auth.updateCurrentUser(user);

      // Return the updated user object.
      return user;
    } catch (e) {
      // Handle errors during the request.
      print('Update profile failed: $e');
      throw cognitoAuthException(
        code: 'update-profile', // Custom error code for this action.
        message: 'Failed to update user.', // Error message.
      );
    }
  }
}
