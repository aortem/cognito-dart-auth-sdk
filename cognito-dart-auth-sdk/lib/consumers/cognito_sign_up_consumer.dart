import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class CognitoSignUpConsumer {
  final String userPoolId;
  final String clientId;
  final String region;

  CognitoSignUpConsumer({
    required this.userPoolId,
    required this.clientId,
    required this.region,
  });

  Future<void> signUp(
    void Function(Map<String, String> userDetails) consumer,
  ) async {
    final userDetails = <String, String>{};
    consumer(userDetails);

    if (!userDetails.containsKey('Username') ||
        !userDetails.containsKey('Password')) {
      throw ArgumentError('Username and password must be provided.');
    }

    final attributes = userDetails.entries
        .where((entry) => entry.key != 'Username' && entry.key != 'Password')
        .map((entry) => {'Name': entry.key, 'Value': entry.value})
        .toList();

    final payload = {
      'ClientId': clientId,
      'Username': userDetails['Username'],
      'Password': userDetails['Password'],
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
        print('✅ User sign-up successful: ${userDetails['Username']}');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('❌ Network error during sign-up: $e');
    }
  }

  void _handleError(http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['message'] ?? 'Unknown error occurred';
    throw Exception('API Error (${response.statusCode}): $errorMessage');
  }
}
