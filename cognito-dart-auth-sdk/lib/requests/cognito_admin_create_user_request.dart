/// AdminCreateUser — Creates a new user in the specified Cognito user pool.
///
/// This request allows administrators to create users directly in a user pool.
///
/// AWS API Reference:
/// https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminCreateUser.html
library cognito_admin_create_user_request;

import 'dart:convert';

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents a name/value pair for user attributes.
///
/// Used for both permanent user attributes and temporary validation data.
class CognitoAttributeType {
  /// The attribute name (e.g., "email", "phone_number", or "custom:attribute")
  final String name;

  /// The attribute value
  final String value;

  /// Creates a new attribute pair
  const CognitoAttributeType({required this.name, required this.value});

  /// Validates the attribute contents
  ///
  /// @throws  CognitoValidationException if name is empty
  void validate() {
    if (name.trim().isEmpty) {
      throw CognitoValidationException('Attribute.name is required.');
    }
    // AWS allows many unicode chars; we keep validation light.
  }

  /// Converts the attribute to JSON format for API requests
  Map<String, dynamic> toJson() => {'Name': name, 'Value': value};
}

/// Enum for message action types when creating users
enum CognitoMessageActionType {
  /// Resend the invitation message
  resend,

  /// Suppress the invitation message
  suppress,
}

/// Maps message action enum to API string values
String _mapMessageAction(CognitoMessageActionType a) {
  switch (a) {
    case CognitoMessageActionType.resend:
      return 'RESEND';
    case CognitoMessageActionType.suppress:
      return 'SUPPRESS';
  }
}

/// Result container for AdminCreateUser operations
class CognitoAdminCreateUserResult {
  /// Raw JSON response from Cognito
  final Map<String, dynamic>? json;

  /// Creates a result with the raw API response
  const CognitoAdminCreateUserResult(this.json);

  /// Convenience accessor for the User object in the response
  Map<String, dynamic>? get user => (json != null && json!.containsKey('User'))
      ? (json!['User'] as Map<String, dynamic>?)
      : null;
}

/// Request class for AdminCreateUser API operation
class CognitoAdminCreateUserRequest {
  /// The user pool ID for the user pool where the user will be created
  final String userPoolId;

  /// The username for the new user
  final String username;

  /// List of user attributes (name/value pairs)
  final List<CognitoAttributeType>? userAttributes;

  /// The delivery mediums for the invitation message
  final List<String>? desiredDeliveryMediums;

  /// Whether to force alias creation
  final bool? forceAliasCreation;

  /// Action to take regarding the invitation message
  final CognitoMessageActionType? messageAction;

  /// Temporary password for the user
  final String? temporaryPassword;

  /// Metadata to pass to Lambda triggers
  final Map<String, String>? clientMetadata;

  /// Temporary attributes for pre sign-up triggers
  final List<CognitoAttributeType>? validationData;

  /// The AWS region for the request
  final String region;

  /// Configured HTTP client
  final CognitoHttpClient httpClient;

  /// Maximum retry attempts
  final int maxRetries;

  /// Request timeout duration
  final Duration requestTimeout;

  /// Creates a new AdminCreateUser request
  CognitoAdminCreateUserRequest({
    required this.userPoolId,
    required this.username,
    required this.region,
    required this.httpClient,
    this.userAttributes,
    this.desiredDeliveryMediums,
    this.forceAliasCreation,
    this.messageAction,
    this.temporaryPassword,
    this.clientMetadata,
    this.validationData,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters
  ///
  /// @throws  CognitoValidationException if any parameters are invalid
  void _validate() {
    // Pool ID pattern: [\w-]+_[0-9a-zA-Z]+
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

    // Validate attributes
    userAttributes?.forEach((a) => a.validate());
    validationData?.forEach((a) => a.validate());

    // Validate DesiredDeliveryMediums
    if (desiredDeliveryMediums != null) {
      const allowed = {'SMS', 'EMAIL'};
      for (final m in desiredDeliveryMediums!) {
        if (!allowed.contains(m)) {
          throw CognitoValidationException(
            "desiredDeliveryMediums contains invalid value '$m' (allowed: SMS, EMAIL).",
          );
        }
      }
    }

    // If mediums imply contact, ensure matching attribute is present
    if ((desiredDeliveryMediums?.contains('EMAIL') ?? false) &&
        !(userAttributes?.any((a) => a.name == 'email') ?? false)) {
      throw CognitoValidationException(
        'EMAIL delivery requires the "email" attribute to be present.',
      );
    }
    if ((desiredDeliveryMediums?.contains('SMS') ?? false) &&
        !(userAttributes?.any((a) => a.name == 'phone_number') ?? false)) {
      throw CognitoValidationException(
        'SMS delivery requires the "phone_number" attribute to be present.',
      );
    }

    // TemporaryPassword validation
    if (temporaryPassword != null && temporaryPassword!.isEmpty) {
      throw CognitoValidationException(
        'temporaryPassword must be omitted or a non-empty string.',
      );
    }

    // clientMetadata keys validation
    if (clientMetadata != null) {
      for (final k in clientMetadata!.keys) {
        if (k.trim().isEmpty) {
          throw CognitoValidationException(
            'clientMetadata keys must be non-empty.',
          );
        }
      }
    }
  }

  /// Builds the request payload for the AWS API
  Map<String, dynamic> _payload() {
    return <String, dynamic>{
      'UserPoolId': userPoolId,
      'Username': username,
      if (userAttributes != null && userAttributes!.isNotEmpty)
        'UserAttributes': userAttributes!.map((e) => e.toJson()).toList(),
      if (validationData != null && validationData!.isNotEmpty)
        'ValidationData': validationData!.map((e) => e.toJson()).toList(),
      if (clientMetadata != null && clientMetadata!.isNotEmpty)
        'ClientMetadata': clientMetadata,
      if (desiredDeliveryMediums != null && desiredDeliveryMediums!.isNotEmpty)
        'DesiredDeliveryMediums': desiredDeliveryMediums,
      if (forceAliasCreation != null) 'ForceAliasCreation': forceAliasCreation,
      if (messageAction != null)
        'MessageAction': _mapMessageAction(messageAction!),
      if (temporaryPassword != null) 'TemporaryPassword': temporaryPassword,
    };
  }

  /// Executes the AdminCreateUser request
  ///
  /// @return Future resolving to AdminCreateUserResult
  /// @throws  CognitoValidationException for invalid parameters
  /// @throws  CognitoServiceException for API failures
  Future<CognitoAdminCreateUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminCreateUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          Map<String, dynamic>? body;
          try {
            body = res.bodyString.isEmpty
                ? null
                : (json.decode(res.bodyString) as Map<String, dynamic>);
          } catch (_) {
            body = null;
          }
          return CognitoAdminCreateUserResult(body);
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminCreateUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminCreateUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminCreateUser unexpected status.',
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
      'AdminCreateUser failed after retries. Last error: $lastError',
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
