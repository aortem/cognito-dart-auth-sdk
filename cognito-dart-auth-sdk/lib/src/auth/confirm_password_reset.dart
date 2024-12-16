import 'dart:convert';
import 'package:cognito_dart_auth_sdk/src/exceptions.dart';

///confirmpassword service
class ConfirmPasswordResetService {
  ///cognito auth instance
  final dynamic auth;

  ///confirmpassword service
  ConfirmPasswordResetService({required this.auth});

  ///confirm password function
  Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'oobCode': oobCode,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw cognitoAuthException(
          code: error['message'],
          message: error['message'],
        );
      }
    } catch (e) {
      throw cognitoAuthException(
        code: 'confirm-password-reset-error',
        message: 'Failed to confirm password reset: ${e.toString()}',
      );
    }
  }
}
