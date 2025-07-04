// admin_confirm_sign_up_consumer.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles AWS Cognito AdminConfirmSignUp calls.
class AortemCognitoAdminConfirmSignUpConsumer {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminConfirmSignUpConsumer({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Confirms a user's signup using admin credentials.
  Future<void> confirmSignUp(
    void Function(Map<String, String> userDetails) consumer,
  ) async {
    final userDetails = <String, String>{};
    consumer(userDetails);

    if (!userDetails.containsKey('Username')) {
      throw ArgumentError('Username must be provided.');
    }

    final payload = {
      'UserPoolId': userPoolId,
      'Username': userDetails['Username'],
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminConfirmSignUp',
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User successfully confirmed: ${userDetails['Username']}');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while confirming user: $e');
    }
  }

  void _handleError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['message'] ?? 'Unknown error occurred';
      throw Exception('API Error (${response.statusCode}): $errorMessage');
    } catch (_) {
      throw Exception('API Error (${response.statusCode}): ${response.body}');
    }
  }
}
