// aortem_cognito_admin_add_user_to_group_consumer.dart
//
// Consumer/builder-style facade for AdminAddUserToGroup.
// Lets callers define/normalize inputs at runtime, then executes Ticket #3 request.

import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_add_user_to_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

/// A tiny builder that lets developers tweak inputs before submission.
/// You can enrich here later (e.g., alias normalization, username canonicalization).
/// Consumer/builder-style facade for AdminAddUserToGroup.
/// Provides a fluent interface for adding users to Cognito groups with runtime input normalization.
class AortemCognitoAdminAddUserToGroupBuilder {
  /// Stores the Cognito User Pool ID
  /// Format should be: [\\w-]+_[0-9a-zA-Z]+
  String? _userPoolId;

  /// Stores the username (can be alias or subject)
  /// Length must be between 1-128 characters after trimming
  String? _username;

  /// Stores the target group name
  /// Length must be between 1-128 characters after trimming
  String? _groupName;

  /// Sets the User Pool ID with validation
  /// @param value The Cognito User Pool ID to set
  /// @return The builder instance for method chaining
  /// @throws AortemCognitoValidationException if value is empty after trimming
  AortemCognitoAdminAddUserToGroupBuilder userPoolId(String value) {
    _userPoolId = value.trim();
    return this;
  }

  /// Sets the username with normalization
  /// @param value The username to set (can be alias or subject)
  /// @return The builder instance for method chaining
  /// @throws AortemCognitoValidationException if value is empty after normalization
  AortemCognitoAdminAddUserToGroupBuilder username(String value) {
    _username = _normalizeUsername(value);
    return this;
  }

  /// Sets the group name with normalization
  /// @param value The group name to set
  /// @return The builder instance for method chaining
  /// @throws AortemCognitoValidationException if value is empty after normalization
  AortemCognitoAdminAddUserToGroupBuilder groupName(String value) {
    _groupName = _normalizeGroup(value);
    return this;
  }

  /// Constructs the final request object after validation
  /// @param region AWS region for the Cognito endpoint
  /// @param httpClient Configured HTTP client for AWS requests
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2)
  /// @param requestTimeout Timeout duration for the request (default: 20 seconds)
  /// @return Configured AortemCognitoAdminAddUserToGroupRequest instance
  /// @throws AortemCognitoValidationException if any required field is missing
  AortemCognitoAdminAddUserToGroupRequest build({
    required String region,
    required AortemCognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final up = _userPoolId?.trim() ?? '';
    final un = _username?.trim() ?? '';
    final gn = _groupName?.trim() ?? '';

    if (up.isEmpty) {
      throw AortemCognitoValidationException('userPoolId is required.');
    }
    if (un.isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    if (gn.isEmpty) {
      throw AortemCognitoValidationException('groupName is required.');
    }

    return AortemCognitoAdminAddUserToGroupRequest(
      userPoolId: up,
      username: un,
      groupName: gn,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }

  /// Normalizes username input
  /// @param raw The raw username input
  /// @return Trimmed username string
  /// @note Can be extended to include case normalization or alias resolution
  String _normalizeUsername(String raw) => raw.trim();

  /// Normalizes group name input
  /// @param raw The raw group name input
  /// @return Trimmed string with collapsed internal whitespace
  /// @note AWS allows many unicode classes - this implementation keeps it ASCII-safe
  String _normalizeGroup(String raw) =>
      raw.trim().replaceAll(RegExp(r'\s+'), ' ');
}

/// High-level consumer facade for adding users to Cognito groups.
/// Provides a one-line execution pattern using builder configuration.
class AortemCognitoAdminAddUserToGroupConsumer {
  /// AWS region for Cognito endpoint (e.g., 'us-east-1')
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for requests (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new consumer instance
  /// @param region AWS region for Cognito endpoint
  /// @param httpClient Configured HTTP client
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Request timeout duration (default: 20 seconds)
  AortemCognitoAdminAddUserToGroupConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes the group addition flow
  /// @param consumer Builder configuration callback
  /// @return Future resolving to the operation result
  /// @throws AortemCognitoValidationException for invalid inputs
  /// @throws AortemCognitoServiceException for AWS service errors
  Future<AortemCognitoAdminAddUserToGroupResult> run(
    void Function(AortemCognitoAdminAddUserToGroupBuilder b) consumer,
  ) async {
    final b = AortemCognitoAdminAddUserToGroupBuilder();
    consumer(b);

    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }
}
