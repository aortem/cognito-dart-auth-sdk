import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class AortemCognitoConfirmSignUpRequest {
  final String region;
  final String clientId;

  AortemCognitoConfirmSignUpRequest({
    required this.region,
    required this.clientId,
  });

  Future<void> confirmSignUp({
    required String username,
    required String confirmationCode,
  }) async {
    if (username.isEmpty || confirmationCode.isEmpty) {
      throw ArgumentError('Username and ConfirmationCode cannot be empty.');
    }

    final payload = {
      'ClientId': clientId,
      'Username': username,
      'ConfirmationCode': confirmationCode,
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.ConfirmSignUp',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User confirmed successfully: $username');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while confirming sign-up: $e');
    }
  }

  void _handleError(http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['message'] ?? 'Unknown error occurred';
    throw Exception('API Error (${response.statusCode}): $errorMessage');
  }
}
