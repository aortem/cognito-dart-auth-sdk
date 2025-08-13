// aortem_cognito_admin_link_provider_for_user_request.dart
//
// AdminLinkProviderForUser — Links an external identity provider (IdP) identity (SourceUser)
// to an existing local/federated user (DestinationUser) in a Cognito user pool.
// AWS Target: AWSCognitoIdentityProviderService.AdminLinkProviderForUser
//
// Depends on shared types:
// - AortemCognitoHttpClient
// - AortemCognitoValidationException
// - AortemCognitoServiceException

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Represents a user identifier for provider linking operations.
///
/// This model encapsulates the necessary information to identify a user
/// either in Cognito or an external identity provider.
class AortemCognitoProviderUserLinkingIdentifier {
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
  const AortemCognitoProviderUserLinkingIdentifier({
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
  /// - [AortemCognitoValidationException] if required fields are invalid
  void validate({required bool isSourceUser}) {
    if (providerName.trim().isEmpty) {
      throw AortemCognitoValidationException('providerName is required.');
    }
    if (providerAttributeValue.trim().isEmpty) {
      throw AortemCognitoValidationException(
        'providerAttributeValue is required.',
      );
    }

    if (isSourceUser) {
      // For social IdPs, providerAttributeName must be Cognito_Subject.
      if (providerAttributeName != null && providerAttributeName!.isEmpty) {
        throw AortemCognitoValidationException(
          'providerAttributeName, if provided, must be non-empty.',
        );
      }
    } else {
      // Destination: providerAttributeName is ignored by service
      if (providerAttributeName != null && providerAttributeName!.isEmpty) {
        throw AortemCognitoValidationException(
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
class AortemCognitoAdminLinkProviderForUserResult {
  /// Creates a success result instance.
  const AortemCognitoAdminLinkProviderForUserResult();
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
/// final request = AortemCognitoAdminLinkProviderForUserRequest(
///   userPoolId: 'us-east-1_abc123',
///   destinationUser: AortemCognitoProviderUserIdentifier(
///     providerName: 'Cognito',
///     providerAttributeValue: 'local_username',
///   ),
///   sourceUser: AortemCognitoProviderUserIdentifier(
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
/// } on AortemCognitoValidationException catch (e) {
///   print('Validation error: ${e.message}');
/// } on AortemCognitoServiceException catch (e) {
///   print('Service error (${e.statusCode}): ${e.message}');
/// }
/// ```
class AortemCognitoAdminLinkProviderForUserRequest {
  /// The ID of the user pool containing the users
  final String userPoolId;

  /// The destination user (must be a Cognito user)
  final AortemCognitoProviderUserLinkingIdentifier destinationUser;

  /// The source user (must be from an external identity provider)
  final AortemCognitoProviderUserLinkingIdentifier sourceUser;

  /// The AWS region where the user pool is located
  final String region;

  /// The HTTP client for making authenticated requests
  final AortemCognitoHttpClient httpClient;

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
  AortemCognitoAdminLinkProviderForUserRequest({
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
  /// - [AortemCognitoValidationException] if any parameters are invalid
  void _validate() {
    final poolRe = RegExp(r'^[\w-]+_[0-9A-Za-z]+$');
    if (userPoolId.trim().isEmpty || !poolRe.hasMatch(userPoolId)) {
      throw AortemCognitoValidationException(
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
  /// - [AortemCognitoAdminLinkProviderForUserResult] on success
  ///
  /// Throws:
  /// - [AortemCognitoValidationException] for invalid parameters
  /// - [AortemCognitoServiceException] for API failures
  Future<AortemCognitoAdminLinkProviderForUserResult> execute() async {
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
          return const AortemCognitoAdminLinkProviderForUserResult();
        }

        if (res.statusCode >= 400 && res.statusCode < 500) {
          throw AortemCognitoServiceException(
            'AdminLinkProviderForUser failed. Body: ${res.bodyString}',
            statusCode: res.statusCode,
          );
        }

        if (res.statusCode >= 500) {
          throw AortemCognitoServiceException(
            'AdminLinkProviderForUser temporary failure.',
            statusCode: res.statusCode,
          );
        }

        throw AortemCognitoServiceException(
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

    throw AortemCognitoServiceException(
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
