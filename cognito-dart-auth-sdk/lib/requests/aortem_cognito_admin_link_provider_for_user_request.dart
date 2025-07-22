// admin_link_provider_for_user_request.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class AortemCognitoAdminLinkProviderForUserRequest {
  final String userPoolId;
  final String region;

  AortemCognitoAdminLinkProviderForUserRequest({
    required this.userPoolId,
    required this.region,
  });

  Future<void> linkProviderForUser({
    required String username,
    required String providerName,
    required String providerUserId,
  }) async {
    if (username.isEmpty || providerName.isEmpty || providerUserId.isEmpty) {
      throw ArgumentError('All parameters must be provided.');
    }

    final payload = {
      'UserPoolId': userPoolId,
      'DestinationUser': {
        'ProviderName': 'Cognito',
        'ProviderAttributeValue': username,
      },
      'SourceUser': {
        'ProviderName': providerName,
        'ProviderAttributeValue': providerUserId,
      },
    };

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target':
          'AWSCognitoIdentityProviderService.AdminLinkProviderForUser',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print(
          '✅ Successfully linked provider "$providerName" to user "$username".',
        );
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('❌ Network error while linking provider: $e');
    }
  }

  void _handleError(http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['message'] ?? 'Unknown error occurred';
    throw Exception('API Error (${response.statusCode}): $errorMessage');
  }
}
