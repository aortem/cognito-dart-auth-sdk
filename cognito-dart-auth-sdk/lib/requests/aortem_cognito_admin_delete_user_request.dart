// admin_delete_user_request.dart

import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Deletes a Cognito user via AdminDeleteUser API.
class AortemCognitoAdminDeleteUserRequest {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminDeleteUserRequest({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<void> deleteUser({required String username}) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminDeleteUser',
    };
    final payload = {'UserPoolId': userPoolId, 'Username': username};

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User "$username" successfully deleted.');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while deleting user: $e');
    }
  }

  void _handleError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Unknown error occurred.';
      throw Exception('API Error (${response.statusCode}): $message');
    } catch (_) {
      throw Exception('API Error (${response.statusCode}): ${response.body}');
    }
  }
}
