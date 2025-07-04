// admin_create_user_request.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Admin class to create new users in a Cognito User Pool.
class AortemCognitoAdminCreateUserRequest {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  /// Initializes with [userPoolId] and [region]. Optionally pass [httpClient].
  AortemCognitoAdminCreateUserRequest({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Creates a new user with [username], [email], and optional [attributes].
  ///
  /// Throws [ArgumentError] for missing required fields.
  /// Throws [Exception] for network or API errors.
  Future<void> createUser({
    required String username,
    required String email,
    Map<String, String>? attributes,
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username must not be empty.');
    }
    if (email.isEmpty) {
      throw ArgumentError('Email must not be empty.');
    }

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminCreateUser',
    };

    final userAttributes = [
      {'Name': 'email', 'Value': email},
      if (attributes != null)
        ...attributes.entries.map(
          (entry) => {'Name': entry.key, 'Value': entry.value},
        ),
    ];

    final payload = {
      'UserPoolId': userPoolId,
      'Username': username,
      'UserAttributes': userAttributes,
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User "$username" successfully created.');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while creating user "$username": $e');
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
