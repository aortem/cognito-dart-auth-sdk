// admin_delete_user_attributes_consumer.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// SDK for deleting user attributes using a consumer-style configuration.
class AortemCognitoAdminDeleteUserAttributesConsumer {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminDeleteUserAttributesConsumer({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Executes a delete user attributes request using a consumer.
  ///
  /// The [consumer] must configure `Username` and `UserAttributeNames`.
  Future<void> deleteUserAttributes(
    void Function(Map<String, dynamic> userDetails) consumer,
  ) async {
    final userDetails = <String, dynamic>{};
    consumer(userDetails);

    if (!userDetails.containsKey('Username') ||
        (userDetails['Username'] as String).isEmpty) {
      throw ArgumentError('Username must be provided.');
    }

    if (!userDetails.containsKey('UserAttributeNames') ||
        (userDetails['UserAttributeNames'] as List).isEmpty) {
      throw ArgumentError('Attribute names must be provided.');
    }

    final payload = {
      'UserPoolId': userPoolId,
      'Username': userDetails['Username'],
      'UserAttributeNames': userDetails['UserAttributeNames'],
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/json',
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
        print(
          '[SUCCESS] Deleted attributes for user: ${userDetails['Username']}',
        );
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
