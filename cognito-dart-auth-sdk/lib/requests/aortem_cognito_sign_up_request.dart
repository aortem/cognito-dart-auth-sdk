import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

class AortemCognitoSignUpRequest {
  final String userPoolId;
  final String clientId;
  final String region;

  AortemCognitoSignUpRequest({
    required this.userPoolId,
    required this.clientId,
    required this.region,
  });

  Future<void> signUp({
    required String username,
    required String password,
    required Map<String, String> userAttributes,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password cannot be empty.');
    }
    if (userAttributes.isEmpty) {
      throw ArgumentError('User attributes must be provided.');
    }

    final attributes = userAttributes.entries
        .map((entry) => {'Name': entry.key, 'Value': entry.value})
        .toList();

    final payload = {
      'ClientId': clientId,
      'Username': username,
      'Password': password,
      'UserAttributes': attributes,
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/json',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.SignUp',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User sign-up successful: $username');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error during sign-up: $e');
    }
  }

  void _handleError(http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['message'] ?? 'Unknown error occurred';
    throw Exception('API Error (${response.statusCode}): $errorMessage');
  }
}
