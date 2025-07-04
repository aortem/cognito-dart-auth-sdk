// admin_add_user_to_group_consumer.dart
import 'aortem-cognito-admin-add-user-to-group-request.dart';

/// Builder class to configure the request via consumer.
class AortemCognitoAdminAddUserToGroupBuilder {
  String? username;
  String? groupName;

  AortemCognitoAdminAddUserToGroupBuilder();
}

/// Consumer-style class to dynamically add users to Cognito groups.
class AortemCognitoAdminAddUserToGroupConsumer {
  final String userPoolId;
  final String region;
  final Future<http.Request> Function(http.Request request)? signer;

  AortemCognitoAdminAddUserToGroupConsumer({
    required this.userPoolId,
    required this.region,
    this.signer,
  });

  /// Accepts a consumer function that builds the request dynamically.
  Future<void> consume(
    void Function(AortemCognitoAdminAddUserToGroupBuilder builder) configure,
  ) async {
    final builder = AortemCognitoAdminAddUserToGroupBuilder();
    configure(builder);

    // Validate
    if (builder.username == null || builder.username!.isEmpty) {
      throw AortemCognitoAdminAddUserToGroupException('Username is required.');
    }
    if (builder.groupName == null || builder.groupName!.isEmpty) {
      throw AortemCognitoAdminAddUserToGroupException(
        'Group name is required.',
      );
    }

    // Create and send request
    final request = AortemCognitoAdminAddUserToGroupRequest(
      username: builder.username!,
      groupName: builder.groupName!,
      userPoolId: userPoolId,
      region: region,
      signer: signer,
    );

    await request.send();
  }
}
