import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Request class for AdminUpdateAuthEventFeedback API operation.
///
/// This class handles the AdminUpdateAuthEventFeedback operation, which allows
/// administrators to provide feedback on authentication events for risk evaluation.
/// This API is typically used with AWS Cognito's risk-based authentication features
/// to help improve the accuracy of risk assessments by providing feedback on
/// whether authentication events were legitimate or fraudulent.
///
/// The feedback helps AWS Cognito's adaptive authentication features learn
/// and improve their risk assessment algorithms over time.
///
/// Example:
/// ```dart
/// final request =    CognitoAdminUpdateAuthEventFeedbackRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   eventId: 'example-event-id-123',
///   feedbackValue: 'Valid', // or 'Invalid' for fraudulent events
///   region: 'us-west-2',
///   httpClient: httpClient,
/// );
///
/// final result = await request.execute();
/// ```
class CognitoAdminUpdateAuthEventFeedbackRequest {
  /// The ID of the user pool where the user exists.
  ///
  /// Must be a valid Cognito User Pool ID in the format: `region_randomId`
  final String userPoolId;

  /// The username of the user associated with the authentication event.
  ///
  /// This can be the user's actual username, email, or phone number,
  /// depending on how the user pool is configured.
  final String username;

  /// The unique identifier of the authentication event to provide feedback for.
  ///
  /// This event ID is typically obtained from authentication logs,
  /// CloudTrail events, or risk assessment reports.
  final String eventId;

  /// The feedback value indicating whether the event was valid or invalid.
  ///
  /// Must be one of the following values:
  /// - "Valid": The authentication event was legitimate
  /// - "Invalid": The authentication event was fraudulent or suspicious
  final String feedbackValue;

  /// AWS region where the User Pool is located (e.g., "us-west-2").
  final String region;

  /// SigV4-capable HTTP client for making authenticated requests to AWS.
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for transient failures (default: 2).
  final int maxRetries;

  /// Per-request timeout duration (default: 20 seconds).
  final Duration requestTimeout;

  /// Creates a new AdminUpdateAuthEventFeedback request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [username]: Required - The username of the user
  /// - [eventId]: Required - The unique event identifier
  /// - [feedbackValue]: Required - Feedback value ("Valid" or "Invalid")
  /// - [region]: Required - AWS region identifier
  /// - [httpClient]: Required - HTTP client for making requests
  /// - [maxRetries]: Optional - Maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional - Request timeout (default: 20 seconds)
  ///
  /// Throws [ArgumentError] if required parameters are missing, empty, or invalid.
  CognitoAdminUpdateAuthEventFeedbackRequest({
    required this.userPoolId,
    required this.username,
    required this.eventId,
    required this.feedbackValue,
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  }) {
    if (userPoolId.trim().isEmpty) {
      throw ArgumentError('userPoolId is required');
    }
    if (username.trim().isEmpty) {
      throw ArgumentError('username is required');
    }
    if (eventId.trim().isEmpty) {
      throw ArgumentError('eventId is required');
    }
    if (!(feedbackValue == 'Valid' || feedbackValue == 'Invalid')) {
      throw ArgumentError('feedbackValue must be "Valid" or "Invalid"');
    }
  }

  /// Executes the AdminUpdateAuthEventFeedback API request.
  ///
  /// This method:
  /// 1. Validates the required parameters
  /// 2. Constructs the appropriate JSON payload
  /// 3. Signs and sends the request using SigV4 authentication
  /// 4. Handles the response and returns the result
  ///
  /// The API target is `AWSCognitoIdentityProviderService.AdminUpdateAuthEventFeedback`
  /// and requires administrator privileges.
  ///
  /// Returns:
  /// A Future that completes with [   CognitoAdminUpdateAuthEventFeedbackResult]
  /// on successful feedback submission.
  ///
  /// Throws:
  /// - [ArgumentError] for invalid or missing parameters
  /// - [Exception] for HTTP errors, network failures, or AWS service errors
  /// - Various AWS Cognito-specific exceptions for authentication or authorization failures
  Future<CognitoAdminUpdateAuthEventFeedbackResult> execute() async {
    final Map<String, dynamic> payload = {
      'UserPoolId': userPoolId,
      'Username': username,
      'EventId': eventId,
      'FeedbackValue': feedbackValue,
    };

    int attempt = 0;
    Object? lastError;

    while (attempt <= maxRetries) {
      try {
        final resp = await httpClient.post(
          region: region,
          xAmzTarget:
              'AWSCognitoIdentityProviderService.AdminUpdateAuthEventFeedback',
          payload: payload,
          timeout: requestTimeout,
        );

        if (resp.statusCode == 200) {
          return CognitoAdminUpdateAuthEventFeedbackResult(
            success: true,
            rawResponse: resp.jsonBody ?? {},
          );
        }

        // Handle 4xx errors (client errors) - non-retryable
        if (resp.statusCode >= 400 && resp.statusCode < 500) {
          throw Exception(
            'AdminUpdateAuthEventFeedback failed with status ${resp.statusCode}. Body: ${resp.bodyString}',
          );
        }

        // Handle 5xx errors (server errors) - potentially retryable
        if (resp.statusCode >= 500) {
          throw Exception(
            'AdminUpdateAuthEventFeedback temporary failure with status ${resp.statusCode}',
          );
        }

        throw Exception(
          'AdminUpdateAuthEventFeedback unexpected status ${resp.statusCode}',
        );
      } catch (e) {
        lastError = e;
        if (!_isTransient(e) || attempt == maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } finally {
        attempt++;
      }
    }

    throw Exception(
      'AdminUpdateAuthEventFeedback failed after $maxRetries retries. Last error: $lastError',
    );
  }

  /// Determines if an error is transient and worth retrying.
  ///
  /// Transient errors include network timeouts, socket exceptions, and
  /// server-side 5xx errors that might be resolved by retrying.
  ///
  /// Parameters:
  /// - [e]: The exception to check
  ///
  /// Returns:
  /// true if the error is transient and retryable, false otherwise
  bool _isTransient(Object e) {
    final s = e.toString();
    return s.contains('temporary') ||
        s.contains('SocketException') ||
        s.contains('TimeoutException') ||
        s.contains('503') ||
        s.contains('500');
  }
}

/// Represents the successful result of an AdminUpdateAuthEventFeedback operation.
///
/// This class provides access to the raw response data from the AWS Cognito
/// service. The AdminUpdateAuthEventFeedback API typically returns an HTTP 200 status
/// with an empty or minimal response body on success, indicating that the feedback
/// was successfully recorded.
class CognitoAdminUpdateAuthEventFeedbackResult {
  /// Indicates whether the feedback submission operation was successful.
  ///
  /// For successful AdminUpdateAuthEventFeedback operations, this should always be true.
  /// If the operation fails, an exception is thrown instead of returning a result.
  final bool success;

  /// The raw JSON response from the AWS Cognito service.
  ///
  /// Contains the complete response data, which may include additional
  /// metadata or confirmation details from the service. For this API,
  /// the response body is typically empty on success.
  final Map<String, dynamic> rawResponse;

  /// Creates a new result instance for AdminUpdateAuthEventFeedback operation.
  ///
  /// Parameters:
  /// - [success]: Required - Whether the operation was successful
  /// - [rawResponse]: Required - The raw JSON response from AWS Cognito
  CognitoAdminUpdateAuthEventFeedbackResult({
    required this.success,
    required this.rawResponse,
  });
}
