// admin_confirm_sign_up_request.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Confirms a user's sign-up in a Cognito User Pool by an administrator.
class AortemCognitoAdminConfirmSignUpRequest {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  /// Initializes the request with required [userPoolId] and [region].
  AortemCognitoAdminConfirmSignUpRequest({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Confirms the sign-up for a given [username].
  ///
  /// Throws [ArgumentError] if [username] is null or empty.
  /// Throws [Exception] on network or API errors.
  Future<void> confirmUser({required String username}) async {
    if (username.isEmpty) {
      throw ArgumentError('Username must not be empty.');
    }

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminConfirmSignUp',
    };
    final payload = {
      'UserPoolId': userPoolId,
      'Username': username,
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User "$username" successfully confirmed.');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while confirming user "$username": $e');
    }
  }

  void _handleError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Unknown error occurred.';
      throw Exception(
          'API Error (${response.statusCode}): $message');
    } catch (_) {
      throw Exception(
          'API Error (${response.statusCode}): ${response.body}');
    }
  }
}
