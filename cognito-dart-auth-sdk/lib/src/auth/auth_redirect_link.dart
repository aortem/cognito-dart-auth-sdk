import 'dart:developer';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';
import '../../cognito_dart_auth_sdk.dart';

/// A service class for handling sign-in with redirect functionality using cognito.
///
/// This class uses cognito's REST API to sign in with an identity provider (IDP)
/// by sending an ID token and provider ID, and then updating the cognito Auth
/// user instance accordingly.
class SignInWithRedirectService {
  /// The cognito authentication instance for managing user authentication.
  final cognitoAuth auth;

  /// Creates a new instance of [SignInWithRedirectService].
  ///
  /// The [auth] parameter is required to interact with the cognito Authentication API.
  SignInWithRedirectService({required this.auth});

  /// Signs in a user with a redirect URI, ID token, and provider ID.
  ///
  /// This method sends an HTTP POST request to cognito's REST API, using the provided
  /// [redirectUri], [idToken], and [providerId] to authenticate the user. If successful,
  /// it returns a [UserCredential] object containing the authenticated user's data.
  ///
  /// If the sign-in fails, it logs the error and returns `null`.
  ///
  /// [redirectUri]: The URI to which cognito should redirect after successful authentication.
  /// [idToken]: The ID token provided by the identity provider for the user.
  /// [providerId]: The ID of the identity provider (e.g., 'google.com').
  ///
  /// Returns a [UserCredential] object on success, or `null` if the sign-in fails.
  Future<UserCredential?> signInWithRedirect(
      String redirectUri, String idToken, String providerId) async {
    try {
      // cognito REST API URL for signing in with an identity provider
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=${auth.apiKey}';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'postBody': 'access_token=$idToken&providerId=$providerId',
          'requestUri': redirectUri,
          'returnSecureToken': true,
        }),
      );

      // Process successful response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Create a UserCredential instance from response data
        final userCredential = UserCredential.fromJson(responseData);

        // Update current user in cognito authentication
        auth.updateCurrentUser(userCredential.user);
        log("Current user ID token: ${userCredential.user.idToken}");

        // Set current user in cognito app instance
        cognitoApp.instance.setCurrentUser(userCredential.user);

        return userCredential;
      } else {
        log('Error response body: ${response.body}');
        return null;
      }
    } catch (error) {
      log('Error occurred during sign in: $error');
    }
    return null;
  }
}
