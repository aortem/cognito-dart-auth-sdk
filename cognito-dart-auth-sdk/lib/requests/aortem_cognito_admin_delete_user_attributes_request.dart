// admin_delete_user_attributes_request.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// SDK to delete user attributes from AWS Cognito User Pool.
class AortemCognitoAdminDeleteUserAttributesRequest {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminDeleteUserAttributesRequest({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Deletes specific user attributes from Cognito.
  ///
  /// [username] - the Cognito username.
  /// [attributeNames] - list of attribute names (e.g., 'custom:example').
  ///
  /// Throws:
  /// - [ArgumentError] if username or attributes are missing.
  /// - [Exception] for network/API errors.
  Future<void> deleteUserAttributes({
    required String username,
    required List<String> attributeNames,
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }
    if (attributeNames.isEmpty) {
      throw ArgumentError('Attribute names cannot be empty.');
    }

    final payload = {
      'UserPoolId': userPoolId,
      'Username': username,
      'UserAttributeNames': attributeNames,
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target':
          'AWSCognitoIdentityProviderService.AdminDeleteUserAttributes',
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('[SUCCESS] Deleted attributes for user: $username');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while deleting user attributes: $e');
    }
  }

  void _handleError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Unknown error occurred';
      throw Exception('API Error (${response.statusCode}): $message');
    } catch (_) {
      throw Exception('API Error (${response.statusCode}): ${response.body}');
    }
  }
}
