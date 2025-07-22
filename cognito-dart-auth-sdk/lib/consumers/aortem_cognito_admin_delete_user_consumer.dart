// admin_delete_user_consumer.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Consumer-based class to delete a user from Cognito User Pool.
class AortemCognitoAdminDeleteUserConsumer {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminDeleteUserConsumer({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<void> deleteUser(
    void Function(Map<String, String> userDetails) consumer,
  ) async {
    final userDetails = <String, String>{};
    consumer(userDetails);

    if (!userDetails.containsKey('Username') ||
        userDetails['Username']!.isEmpty) {
      throw ArgumentError('Username must be provided.');
    }

    final payload = {
      'UserPoolId': userPoolId,
      'Username': userDetails['Username'],
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminDeleteUser',
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('✅ User deleted: ${userDetails['Username']}');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('❌ Network error while deleting user: $e');
    }
  }

  void _handleError(http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['message'] ?? 'Unknown error occurred';
    throw Exception('API Error (${response.statusCode}): $errorMessage');
  }
}
