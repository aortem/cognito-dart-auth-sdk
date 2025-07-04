// admin_add_user_to_group_request.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Class to add a user to a specific group in a Cognito User Pool.
class AortemCognitoAdminAddUserToGroupRequest {
  final String username;
  final String groupName;
  final String userPoolId;
  final String region;
  final Future<http.Request> Function(http.Request request)? signer;

  AortemCognitoAdminAddUserToGroupRequest({
    required this.username,
    required this.groupName,
    required this.userPoolId,
    required this.region,
    this.signer,
  }) {
    _validate();
  }

  void _validate() {
    if (username.isEmpty) {
      throw AortemCognitoAdminAddUserToGroupException(
        'Username must not be empty.',
      );
    }
    if (groupName.isEmpty) {
      throw AortemCognitoAdminAddUserToGroupException(
        'Group name must not be empty.',
      );
    }
    if (userPoolId.isEmpty || region.isEmpty) {
      throw AortemCognitoAdminAddUserToGroupException(
        'UserPoolId and Region must not be empty.',
      );
    }
  }

  /// Sends the AdminAddUserToGroup API request to AWS Cognito.
  Future<http.Response> send() async {
    final uri = Uri.https('cognito-idp.$region.amazonaws.com', '/');

    final payload = {
      'Username': username,
      'GroupName': groupName,
      'UserPoolId': userPoolId,
    };

    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.AdminAddUserToGroup',
      })
      ..body = jsonEncode(payload);

    final signedRequest = signer != null ? await signer!(request) : request;
    final streamedResponse = await signedRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw AortemCognitoAdminAddUserToGroupException(
        'Failed to add user to group: ${response.body}',
      );
    }

    return response;
  }
}
