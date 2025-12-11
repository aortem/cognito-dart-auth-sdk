import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class CognitoConfirmSignUpConsumer {
  final String region;
  final String clientId;

  CognitoConfirmSignUpConsumer({required this.region, required this.clientId});

  Future<void> confirmSignUp(
    void Function(Map<String, String> userDetails) consumer,
  ) async {
    final userDetails = <String, String>{};
    consumer(userDetails);

    if (!userDetails.containsKey('Username') ||
        !userDetails.containsKey('ConfirmationCode')) {
      throw ArgumentError('Username and ConfirmationCode must be provided.');
    }

    final payload = {
      'ClientId': clientId,
      'Username': userDetails['Username'],
      'ConfirmationCode': userDetails['ConfirmationCode'],
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/json',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.ConfirmSignUp',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User confirmed successfully: ${userDetails['Username']}');
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
