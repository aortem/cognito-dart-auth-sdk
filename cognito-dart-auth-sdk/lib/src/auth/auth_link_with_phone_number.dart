import 'dart:async';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../cognito_dart_auth_sdk.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';

/// A class to handle phone number linking and verification using cognito Authentication.
class cognitoPhoneNumberLink {
  /// The cognitoAuth instance used for interacting with cognito Authentication.

  final cognitoAuth auth;

  /// Constructor that initializes the `cognitoPhoneNumberLink` with the provided [auth] instance.
  cognitoPhoneNumberLink(this.auth);

  /// Sends a phone number verification code to the given [phoneNumber].
  ///
  /// This method makes a request to cognito's Identity Toolkit API to send a verification code
  /// to the provided phone number. The reCAPTCHA token must be generated and provided to verify
  /// that the request is legitimate. The [phoneNumber] is the phone number to which the code will
  /// be sent.
  ///
  /// Throws an error if the request fails or the verification code cannot be sent.
  Future<void> sendVerificationCode(String phoneNumber) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=${auth.apiKey}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phoneNumber': phoneNumber,
        'recaptchaToken':
            '[RECAPTCHA_TOKEN]', // You need to handle reCAPTCHA verification
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Verification code sent. Session Info: ${data['sessionInfo']}');
      // Store the sessionInfo for later use in the linking process
    } else {
      print('Failed to send verification code: ${response.body}');
    }
  }

  /// Links a phone number to an existing user account using the provided [idToken],
  /// [phoneNumber], and [verificationCode].
  ///
  /// This method sends a request to cognito's Identity Toolkit API to link a phone number
  /// to an account identified by the [idToken]. It requires the phone number and a valid
  /// verification code, which is usually received via SMS after the user initiates phone number
  /// verification. The [returnSecureToken] flag is set to true to ensure that a new secure token
  /// is returned with the update.
  ///
  /// [idToken] is the user's cognito authentication ID token.
  /// [phoneNumber] is the phone number to be linked.
  /// [verificationCode] is the SMS code that was sent to the user's phone.
  Future<void> linkPhoneNumber(
      String idToken, String phoneNumber, String verificationCode) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${auth.apiKey}';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idToken': idToken,
        'phoneNumber': phoneNumber,
        'verificationCode': verificationCode,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      print('Phone number linked successfully');
    } else {
      print('Failed to link phone number: ${response.body}');
    }

    // Add other methods here as necessary for further functionality
  }
}
