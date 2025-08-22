//    cognito_admin_link_provider_for_user_request.dart
//
// AdminLinkProviderForUser — Links an external identity provider (IdP) identity (SourceUser)
// to an existing local/federated user (DestinationUser) in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminLinkProviderForUser
//
// Depends on shared types:
// -    CognitoHttpClient
// -    CognitoValidationException
// -    CognitoServiceException

import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Represents a user identifier for provider linking operations.
///
/// This model encapsulates the necessary information to identify a user
/// either in Cognito or an external identity provider.
class CognitoProviderUserLinkingIdentifier {
  /// The name of the identity provider.
  ///
  /// For Cognito users, this must be "Cognito".
  /// For external providers, this should match the configured provider name.
  final String providerName;

  /// The value that uniquely identifies the user in the specified provider.
  ///
  /// For Cognito users, this should be the username.
  /// For external providers, this is typically a unique subject identifier.
  final String providerAttributeValue;

  /// The attribute name used to map the user identity (optional).
  ///
  /// For social providers, this is typically "Cognito_Subject".
  /// For OIDC/SAML providers, this can be a mapped claim name.
  /// Ignored when providerName is "Cognito".
  final String? providerAttributeName;

  /// Creates a new provider user identifier.
  const CognitoProviderUserLinkingIdentifier({
    required this.providerName,
    required this.providerAttributeValue,
    this.providerAttributeName,
  });

  /// Validates the identifier configuration.
  ///
  /// Parameters:
  /// - [isSourceUser]: Whether this identifier is for the source (external) user
  ///
  /// Throws:
  /// - [CognitoValidationException] if required fields are invalid
  void validate({required bool isSourceUser}) {
    if (providerName.trim().isEmpty) {
      throw CognitoValidationException('providerName is required.');
    }
    if (providerAttributeValue.trim().isEmpty) {
      throw CognitoValidationException('providerAttributeValue is required.');
    }

    if (isSourceUser) {
      // For social IdPs, providerAttributeName must be Cognito_Subject.
      if (providerAttributeName != null && providerAttributeName!.isEmpty) {
        throw CognitoValidationException(
          'providerAttributeName, if provided, must be non-empty.',
        );
      }
    } else {
      // Destination: providerAttributeName is ignored by service
      if (providerAttributeName != null && providerAttributeName!.isEmpty) {
        throw CognitoValidationException(
          'providerAttributeName, if provided, must be non-empty.',
        );
      }
    }
  }

  /// Converts the identifier to a JSON map for API requests.
  Map<String, dynamic> toJson() => {
    'ProviderName': providerName,
    if (providerAttributeName != null)
      'ProviderAttributeName': providerAttributeName,
    'ProviderAttributeValue': providerAttributeValue,
  };
}

/// Represents a successful response from AdminLinkProviderForUser API.
///
/// Note: The API returns an empty response on success (HTTP 200).
/// This class exists for type safety and consistency.
class CognitoAdminLinkProviderForUserResult {
  /// Creates a success result instance.
  const CognitoAdminLinkProviderForUserResult();
}

/// Request wrapper for AdminLinkProviderForUser API operation.
///
/// This class handles linking an external identity provider user (source)
/// to an existing Cognito user (destination).
///
/// Important Notes:
/// - DestinationUser must have providerName = "Cognito"
/// - SourceUser must be from a federated identity provider
/// - Maximum of 5 linked identities per user
/// - ProviderAttributeName is ignored for destination users
///
/// Example Usage:
/// ```dart
/// final request =    CognitoAdminLinkProviderForUserRequest(
///   userPoolId: 'us-east-1_abc123',
///   destinationUser:    CognitoProviderUserIdentifier(
///     providerName: 'Cognito',
///     providerAttributeValue: 'local_username',
///   ),
///   sourceUser:    CognitoProviderUserIdentifier(
///     providerName: 'Google',
///     providerAttributeName: 'Cognito_Subject',
///     providerAttributeValue: 'google_user_id',
///   ),
///   region: 'us-east-1',
///   httpClient: myHttpClient,
/// );
///
/// try {
///   await request.execute();
///   print('Users linked successfully');
/// } on    CognitoValidationException catch (e) {
///   print('Validation error: ${e.message}');
/// } on    CognitoServiceException catch (e) {
///   print('Service error (${e.statusCode}): ${e.message}');
/// }
/// ```
class CognitoAdminLinkProviderForUserRequest {
  /// The ID of the user pool containing the users
  final String userPoolId;

  /// The destination user (must be a Cognito user)
  final CognitoProviderUserLinkingIdentifier destinationUser;

  /// The source user (must be from an external identity provider)
  final CognitoProviderUserLinkingIdentifier sourceUser;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2)
  final int maxRetries;

  /// Timeout duration for each request attempt (default: 20 seconds)
  final Duration requestTimeout;

  /// Creates a new link provider request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required Cognito User Pool ID
  /// - [destinationUser]: Required destination user identifier
  /// - [sourceUser]: Required source user identifier
  /// - [region]: Required AWS region
  /// - [httpClient]: Required HTTP client implementation
  /// - [maxRetries]: Optional retry count (default 2)
  /// - [requestTimeout]: Optional timeout per request (default 20 seconds)
  CognitoAdminLinkProviderForUserRequest({
    required this.userPoolId,
    required this.destinationUser,
    required this.sourceUser,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    _validate();
  }

  /// Validates all request parameters.
  ///
  /// Throws:
  /// - [CognitoValidationException] if any parameters are invalid
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw CognitoValidationException(
        'userPoolId is required and must match [\\w-]+_[0-9a-zA-Z]+.',
      );
    }
    destinationUser.validate(isSourceUser: false);
    sourceUser.validate(isSourceUser: true);
  }

  /// Builds the API request payload.
  Map<String, dynamic> _payload() => <String, dynamic>{
    'UserPoolId': userPoolId,
    'DestinationUser': destinationUser.toJson(),
    'SourceUser': sourceUser.toJson(),
  };

  /// Executes the link provider request.
  ///
  /// Handles:
  /// - Automatic retries for transient failures
  /// - Error response conversion
  ///
  /// Returns:
  /// - [   CognitoAdminLinkProviderForUserResult] on success
  ///
  /// Throws:
  /// - [CognitoValidationException] for invalid parameters
  /// - [CognitoServiceException] for API failures
  Future<CognitoAdminLinkProviderForUserResult> execute() async {
    final payload = _payload();

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final res = await httpClient.send(
          service: 'cognito-idp',
          target: 'AWSCognitoIdentityProviderService.AdminLinkProviderForUser',
          region: region,
          payload: payload,
          timeout: requestTimeout,
          headers: const {'Content-Type': 'application/x-amz-json-1.1'},
        );

        if (res.statusCode == 200) {
          return const CognitoAdminLinkProviderForUserResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw CognitoServiceException(
            'AdminLinkProviderForUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw CognitoServiceException(
            'AdminLinkProviderForUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw CognitoServiceException(
          'AdminLinkProviderForUser unexpected status.',
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
      'AdminLinkProviderForUser failed after retries. Last error: $lastError',
    );
  }

  /// Determines if an error is likely transient and worth retrying.
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}
