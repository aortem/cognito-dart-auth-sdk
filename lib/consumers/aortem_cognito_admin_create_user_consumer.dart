// admin_create_user_consumer.dart
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Holds user attributes for dynamic configuration in a consumer function.
class AortemCognitoUserBuilder {
  String? username;
  String? email;
  final Map<String, String> attributes = {};

  void setUsername(String value) => username = value;
  void setEmail(String value) => email = value;
  void addAttribute(String key, String value) => attributes[key] = value;
}

/// Creates Cognito users using a dynamic, consumer-style configuration.
class AortemCognitoAdminCreateUserConsumer {
  final String userPoolId;
  final String region;
  final http.Client httpClient;

  AortemCognitoAdminCreateUserConsumer({
    required this.userPoolId,
    required this.region,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Creates a user using a [consumer] that configures the user details.
  ///
  /// Throws [ArgumentError] if required fields are missing.
  /// Throws [Exception] on API or network errors.
  Future<void> createUser(void Function(AortemCognitoUserBuilder) consumer) async {
    final builder = AortemCognitoUserBuilder();
    consumer(builder);

    if (builder.username == null || builder.username!.isEmpty) {
      throw ArgumentError('Username must be set via the consumer.');
    }
    if (builder.email == null || builder.email!.isEmpty) {
      throw ArgumentError('Email must be set via the consumer.');
    }

    final uri = Uri.parse('https://cognito-idp.$region.amazonaws.com/');
    final headers = {
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminCreateUser',
    };

    final userAttributes = <Map<String, String>>[
      {'Name': 'email', 'Value': builder.email!},
      ...builder.attributes.entries.map((e) => {'Name': e.key, 'Value': e.value}),
    ];

    final payload = {
      'UserPoolId': userPoolId,
      'Username': builder.username,
      'UserAttributes': userAttributes,
    };

    try {
      final response = await httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('User "${builder.username}" created successfully.');
      } else {
        _handleError(response);
      }
    } catch (e) {
      throw Exception('Network error while creating user "${builder.username}": $e');
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
