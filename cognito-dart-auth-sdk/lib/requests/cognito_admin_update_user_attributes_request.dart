import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart'
    show CognitoAttributeType;
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Result of a successful AdminUpdateUserAttributes operation.
class CognitoAdminUpdateUserAttributesResult {
  /// Creates a successful result marker.
  const CognitoAdminUpdateUserAttributesResult();
}

/// Request for the Amazon Cognito AdminUpdateUserAttributes API.
class CognitoAdminUpdateUserAttributesRequest {
  /// The user pool ID that contains the user.
  final String userPoolId;

  /// The target username.
  final String username;

  /// Attributes to update.
  final List<CognitoAttributeType> userAttributes;

  /// Optional client metadata passed to Cognito triggers.
  final Map<String, String>? clientMetadata;

  /// AWS region for the user pool.
  final String region;

  /// SigV4-capable Cognito HTTP client.
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts for transient failures.
  final int maxRetries;

  /// Per-request timeout.
  final Duration requestTimeout;

  /// Creates a validated AdminUpdateUserAttributes request.
  CognitoAdminUpdateUserAttributesRequest({
    required this.userPoolId,
    required this.username,
    required this.userAttributes,
    this.clientMetadata,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

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
    if (userAttributes.isEmpty) {
      throw CognitoValidationException(
        'At least one user attribute must be provided.',
      );
    }
    if (userAttributes.length > 32) {
      throw CognitoValidationException(
        'No more than 32 user attributes may be provided.',
      );
    }
    for (final attribute in userAttributes) {
      attribute.validate();
    }
  }

  Map<String, dynamic> _payload() {
    final payload = <String, dynamic>{
      'UserPoolId': userPoolId,
      'Username': username,
      'UserAttributes': userAttributes.map((a) => a.toJson()).toList(),
    };
    if (clientMetadata != null && clientMetadata!.isNotEmpty) {
      payload['ClientMetadata'] = clientMetadata;
    }
    return payload;
  }

  /// Executes the AdminUpdateUserAttributes request.
  Future<CognitoAdminUpdateUserAttributesResult> execute() async {
    final payload = _payload();
    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final response = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminUpdateUserAttributes',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (response.statusCode == 200) {
          return const CognitoAdminUpdateUserAttributesResult();
        }
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw CognitoServiceException(
            'AdminUpdateUserAttributes failed. Body: ${response.bodyString}',
            statusCode: response.statusCode,
          );
        }
        if (response.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminUpdateUserAttributes temporary failure.',
            statusCode: response.statusCode,
          );
        }
        throw CognitoServiceException(
          'AdminUpdateUserAttributes unexpected status.',
          statusCode: response.statusCode,
        );
      } catch (e) {
        lastError = e;
        if (!_isTransient(e) || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw CognitoServiceException(
      'AdminUpdateUserAttributes failed after retries. Last error: $lastError',
    );
  }

  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
