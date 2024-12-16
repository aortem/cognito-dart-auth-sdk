import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

///revoke access token
class RevokeAccessTokenService {
  final cognitoAuth _auth;

  ///revoke access token
  RevokeAccessTokenService({required cognitoAuth auth}) : _auth = auth;

  ///revoke access token method
  Future<void> revokeAccessToken() async {
    if (_auth.currentUser == null) {
      throw cognitoAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in.',
      );
    }

    try {
      // Get the current user's ID token
      String? idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null) {
        throw cognitoAuthException(
          code: 'no-id-token',
          message: 'Failed to get ID token for current user.',
        );
      }

      // In a real-world scenario, you might want to make an API call to your backend
      // to revoke the token server-side. For example:
      // await _auth.performRequest('revokeToken', {'token': idToken});

      // Sign out the user to invalidate the session
      await _auth.signOut();
    } catch (e) {
      throw cognitoAuthException(
        code: 'revoke-access-token-error',
        message: 'Failed to revoke access token: ${e.toString()}',
      );
    }
  }
}
