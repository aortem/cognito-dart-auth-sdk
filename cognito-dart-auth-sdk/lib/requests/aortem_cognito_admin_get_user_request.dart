/// AdminGetUser — Retrieves detailed user information from a Cognito user pool.
///
/// This request allows administrators to fetch comprehensive details about a user,
/// including attributes, MFA settings, and account status.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminGetUser.html

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// Immutable model representing a Cognito user summary.
///
/// Contains selected fields from the AdminGetUser API response.
///
/// ## Common User Attributes
/// - `email`: The user's email address
/// - `email_verified`: Whether email is verified ('true'/'false')
/// - `phone_number`: The user's phone number
/// - `phone_number_verified`: Whether phone is verified ('true'/'false')
/// - `sub`: The user's unique identifier
/// - `custom:*`: Any custom attributes defined for the user pool
class AortemCognitoUserSummary {
  /// The username (may be an alias or sub)
  final String username;

  /// Whether the user account is enabled
  final bool? enabled;

  /// Map of user attributes (name-value pairs)
  final Map<String, String> attributes;

  /// List of active MFA methods
  final List<String> userMfaSettingList;

  /// Preferred MFA method if set
  final String? preferredMfaSetting;

  /// Creation timestamp in Unix epoch seconds
  final double? userCreateDate;

  /// Last modification timestamp in Unix epoch seconds
  final double? userLastModifiedDate;

  /// Current user status (e.g., 'CONFIRMED', 'FORCE_CHANGE_PASSWORD')
  final String? userStatus;

  /// Creates a new user summary instance
  const AortemCognitoUserSummary({
    required this.username,
    required this.attributes,
    this.enabled,
    this.userMfaSettingList = const [],
    this.preferredMfaSetting,
    this.userCreateDate,
    this.userLastModifiedDate,
    this.userStatus,
  });

  /// Parses user information from Cognito API response
  ///
  /// @param m Raw response map from Cognito API
  /// @return Parsed user summary instance
  factory AortemCognitoUserSummary.fromJson(Map<String, dynamic> m) {
    final attrsList =
        (m['UserAttributes'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];

    final attrs = <String, String>{};
    for (final a in attrsList) {
      final name = (a['Name'] ?? '').toString();
      final value = (a['Value'] ?? '').toString();
      if (name.isNotEmpty) attrs[name] = value;
    }

    final mfaList =
        (m['UserMFASettingList'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return AortemCognitoUserSummary(
      username: (m['Username'] ?? '').toString(),
      enabled: m['Enabled'] is bool ? m['Enabled'] as bool : null,
      attributes: attrs,
      userMfaSettingList: mfaList,
      preferredMfaSetting: m['PreferredMfaSetting'] == null
          ? null
          : m['PreferredMfaSetting'].toString(),
      userCreateDate: m['UserCreateDate'] is num
          ? (m['UserCreateDate'] as num).toDouble()
          : null,
      userLastModifiedDate: m['UserLastModifiedDate'] is num
          ? (m['UserLastModifiedDate'] as num).toDouble()
          : null,
      userStatus: m['UserStatus'] == null ? null : m['UserStatus'].toString(),
    );
  }
}

/// Result container for AdminGetUser operations.
///
/// Wraps the user information returned by the API.
class AortemCognitoAdminGetUserResult {
  /// The user details returned by Cognito
  final AortemCognitoUserSummary user;

  /// Creates a new result instance
  const AortemCognitoAdminGetUserResult(this.user);

  /// Parses the result from an HTTP response
  ///
  /// @param res HTTP response from Cognito
  /// @return Parsed result instance
  /// @throws AortemCognitoServiceException if response is malformed
  factory AortemCognitoAdminGetUserResult.fromHttp(
    AortemCognitoHttpResponse res,
  ) {
    final json = res.jsonBody ?? const <String, dynamic>{};
    if ((json['Username'] ?? '').toString().isEmpty) {
      throw AortemCognitoServiceException(
        'AdminGetUser response missing Username/User object.',
        statusCode: res.statusCode,
        responseBody: json,
      );
    }
    return AortemCognitoAdminGetUserResult(
      AortemCognitoUserSummary.fromJson(json),
    );
  }
}

/// {@template aortem_admin_get_user_request}
/// Request wrapper for the Cognito AdminGetUser API.
///
/// Retrieves detailed information about a user in a Cognito user pool.
///
/// ### Usage
/// ```dart
/// final request = AortemCognitoAdminGetUserRequest(
///   userPoolId: 'us-east-1_abc123',
///   username: 'testuser',
///   region: 'us-east-1',
///   httpClient: httpClient,
/// );
///
/// final result = await request.execute();
/// print('User email: ${result.user.attributes['email']}');
/// ```
///
/// ### Validation
/// - `userPoolId`: Must match `[\w-]+_[0-9a-zA-Z]+`
/// - `username`: 1-128 characters
///
/// ### Error Handling
/// - [AortemCognitoValidationException]: Invalid input parameters
/// - [AortemCognitoServiceException]: API failures or malformed responses
/// {@endtemplate}
class AortemCognitoAdminGetUserRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The username (or alias/sub) to look up
  final String username;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final AortemCognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for the request (default: 20 seconds)
  final Duration requestTimeout;

  /// {@macro aortem_admin_get_user_request}
  AortemCognitoAdminGetUserRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters
  ///
  /// @throws AortemCognitoValidationException if any parameters are invalid
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw AortemCognitoValidationException('username is required.');
    }
    if (username.length > 128) {
      throw AortemCognitoValidationException(
        'username must be <= 128 characters.',
      );
    }
  }

  /// Builds the request payload for the AWS API
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'Username': username,
  };

  /// Executes the AdminGetUser request
  ///
  /// @return Future resolving to AdminGetUserResult with user details
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminGetUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminGetUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return AortemCognitoAdminGetUserResult.fromHttp(res);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminGetUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminGetUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
          'AdminGetUser unexpected status.',
          statusCode: res.statusCode,
        );
      } catch (e) {
        lastError = e;
        final transient = _isTransient(e);
        if (!transient || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw AortemCognitoServiceException(
      'AdminGetUser failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
