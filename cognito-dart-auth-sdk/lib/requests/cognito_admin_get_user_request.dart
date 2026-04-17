import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// AdminGetUser — Retrieves detailed user information from a Cognito user pool.
///
/// This request allows administrators to fetch comprehensive details about a user,
/// including attributes, MFA settings, and account status.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminGetUser.html

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
class CognitoUserSummary {
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
  const CognitoUserSummary({
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
  factory CognitoUserSummary.fromJson(Map<String, dynamic> m) {
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

    return CognitoUserSummary(
      username: (m['Username'] ?? '').toString(),
      enabled: m['Enabled'] is bool ? m['Enabled'] as bool : null,
      attributes: attrs,
      userMfaSettingList: mfaList,
      preferredMfaSetting: m['PreferredMfaSetting']?.toString(),
      userCreateDate: m['UserCreateDate'] is num
          ? (m['UserCreateDate'] as num).toDouble()
          : null,
      userLastModifiedDate: m['UserLastModifiedDate'] is num
          ? (m['UserLastModifiedDate'] as num).toDouble()
          : null,
      userStatus: m['UserStatus']?.toString(),
    );
  }
}

/// Result container for AdminGetUser operations.
///
/// Wraps the user information returned by the API.
class CognitoAdminGetUserResult {
  /// The user details returned by Cognito
  final CognitoUserSummary user;

  /// Creates a new result instance
  const CognitoAdminGetUserResult(this.user);

  /// Parses the result from an HTTP response
  ///
  /// @param res HTTP response from Cognito
  /// @return Parsed result instance
  /// @throws    CognitoServiceException if response is malformed
  factory CognitoAdminGetUserResult.fromHttp(CognitoHttpResponse res) {
    final json = res.jsonBody ?? const <String, dynamic>{};
    if ((json['Username'] ?? '').toString().isEmpty) {
      throw CognitoServiceException(
        'AdminGetUser response missing Username/User object.',
        statusCode: res.statusCode,
        responseBody: json,
      );
    }
    return CognitoAdminGetUserResult(CognitoUserSummary.fromJson(json));
  }
}

/// {@template    admin_get_user_request}
/// Request wrapper for the Cognito AdminGetUser API.
///
/// Retrieves detailed information about a user in a Cognito user pool.
///
/// ### Usage
/// ```dart
/// final request =    CognitoAdminGetUserRequest(
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
/// - [CognitoValidationException]: Invalid input parameters
/// - [CognitoServiceException]: API failures or malformed responses
/// {@endtemplate}
class CognitoAdminGetUserRequest {
  /// The user pool ID where the user is registered
  final String userPoolId;

  /// The username (or alias/sub) to look up
  final String username;

  /// The AWS region for the user pool
  final String region;

  /// Configured HTTP client for AWS requests
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts for failed requests (default: 2)
  final int maxRetries;

  /// Timeout duration for the request (default: 20 seconds)
  final Duration requestTimeout;

  /// {@macro    admin_get_user_request}
  CognitoAdminGetUserRequest({
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
  /// @throws    CognitoValidationException if any parameters are invalid
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    if (username.trim().isEmpty) {
      throw CognitoValidationException('username is required.');
    }
    if (username.length > 128) {
      throw CognitoValidationException('username must be <= 128 characters.');
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
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminGetUserResult> execute() async {
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
          return CognitoAdminGetUserResult.fromHttp(res);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminGetUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminGetUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
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

    throw CognitoServiceException(
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
