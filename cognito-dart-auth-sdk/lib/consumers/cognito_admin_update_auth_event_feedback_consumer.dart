import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_auth_event_feedback_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// Builder class for constructing AdminUpdateAuthEventFeedback requests with
/// a fluent interface pattern.
///
/// This builder provides a method-chaining API to configure all parameters
/// required for providing feedback on authentication events in AWS Cognito.
/// It supports the AdminUpdateAuthEventFeedback operation which is used
/// to provide feedback on risk-based authentication events.
///
/// Example:
/// ```dart
/// final builder =    CognitoAdminUpdateAuthEventFeedbackBuilder()
///   ..userPoolId('us-west-2_EXAMPLE')
///   ..username('testuser')
///   ..eventId('auth-event-12345')
///   ..feedbackValue('Valid');
/// ```
class CognitoAdminUpdateAuthEventFeedbackBuilder {
  String? _userPoolId;
  String? _username;
  String? _eventId;
  String? _feedbackValue;

  /// Sets the User Pool ID where the authentication event occurred.
  ///
  /// This is a required parameter that identifies the Cognito User Pool
  /// for the authentication event feedback operation.
  ///
  /// Example:
  /// ```dart
  /// builder.userPoolId('us-west-2_EXAMPLE');
  /// ```
  CognitoAdminUpdateAuthEventFeedbackBuilder userPoolId(String v) {
    _userPoolId = v;
    return this;
  }

  /// Sets the username of the user associated with the authentication event.
  ///
  /// This is a required parameter that specifies which user account
  /// the authentication event pertains to.
  ///
  /// Example:
  /// ```dart
  /// builder.username('testuser');
  /// ```
  CognitoAdminUpdateAuthEventFeedbackBuilder username(String v) {
    _username = v;
    return this;
  }

  /// Sets the unique identifier of the authentication event.
  ///
  /// This is a required parameter that specifies which specific
  /// authentication event to provide feedback for.
  ///
  /// Example:
  /// ```dart
  /// builder.eventId('auth-event-12345');
  /// ```
  CognitoAdminUpdateAuthEventFeedbackBuilder eventId(String v) {
    _eventId = v;
    return this;
  }

  /// Sets the feedback value indicating whether the event was valid or invalid.
  ///
  /// This is a required parameter that must be one of:
  /// - "Valid": The authentication event was legitimate
  /// - "Invalid": The authentication event was fraudulent or suspicious
  ///
  /// Example:_
  /// ```dart
  /// builder.feedbackValue('Valid');
  /// ```
  CognitoAdminUpdateAuthEventFeedbackBuilder feedbackValue(String v) {
    _feedbackValue = v;
    return this;
  }

  /// Constructs an AdminUpdateAuthEventFeedback request instance.
  ///
  /// Combines all configured parameters into a ready-to-execute request object.
  /// Note: Validation of required parameters is handled by the request class itself.
  ///
  /// Parameters:
  /// - [region]: The AWS region where the User Pool is located
  /// - [httpClient]: The HTTP client to use for the request
  /// - [maxRetries]: Maximum number of retry attempts for the request
  /// - [requestTimeout]: Timeout duration for the HTTP request
  ///
  /// Returns:
  /// A configured [   CognitoAdminUpdateAuthEventFeedbackRequest] instance
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are missing or invalid (handled by request constructor)
  CognitoAdminUpdateAuthEventFeedbackRequest build({
    required String region,
    required CognitoHttpClient httpClient,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return CognitoAdminUpdateAuthEventFeedbackRequest(
      userPoolId: _userPoolId ?? '',
      username: _username ?? '',
      eventId: _eventId ?? '',
      feedbackValue: _feedbackValue ?? '',
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }
}

/// Consumer class that provides a reusable interface for executing
/// AdminUpdateAuthEventFeedback operations with shared configuration.
///
/// This class encapsulates the common configuration (region, HTTP client,
/// retry settings, timeout) and provides a clean API for executing
/// authentication event feedback operations with different parameters for each call.
///
/// Example:
/// ```dart
/// final consumer =    CognitoAdminUpdateAuthEventFeedbackConsumer(
///   region: 'us-west-2',
///   httpClient: httpClient,
/// );
/// ```
class CognitoAdminUpdateAuthEventFeedbackConsumer {
  /// The AWS region where the User Pool is located
  final String region;

  /// The HTTP client used for making requests to AWS Cognito
  final CognitoHttpClient httpClient;

  /// Maximum number of retry attempts for failed requests
  final int maxRetries;

  /// Timeout duration for HTTP requests
  final Duration requestTimeout;

  /// Creates a new AdminUpdateAuthEventFeedback consumer with shared configuration.
  ///
  /// Parameters:
  /// - [region]: Required AWS region identifier (e.g., 'us-west-2')
  /// - [httpClient]: Required HTTP client instance for making requests
  /// - [maxRetries]: Optional maximum retry attempts (default: 2)
  /// - [requestTimeout]: Optional request timeout duration (default: 20 seconds)
  CognitoAdminUpdateAuthEventFeedbackConsumer({
    required this.region,
    required this.httpClient,
    this.maxRetries = 2,
    this.requestTimeout = const Duration(seconds: 20),
  });

  /// Executes an AdminUpdateAuthEventFeedback request with builder-style configuration.
  ///
  /// This method allows callers to provide request parameters through a
  /// fluent builder interface while reusing the consumer's shared configuration
  /// (region, HTTP client, retry settings, timeout).
  ///
  /// Example:
  /// ```dart
  /// final result = await consumer.run((b) => b
  ///   ..userPoolId('us-west-2_EXAMPLE')
  ///   ..username('testuser')
  ///   ..eventId('auth-event-12345')
  ///   ..feedbackValue('Valid'));
  /// ```
  ///
  /// Parameters:
  /// - [fn]: A function that receives and configures a builder instance
  ///
  /// Returns:
  /// A Future that completes with the result of the authentication event feedback operation
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are missing or invalid
  /// - Various network and AWS Cognito service exceptions
  Future<CognitoAdminUpdateAuthEventFeedbackResult> run(
    void Function(CognitoAdminUpdateAuthEventFeedbackBuilder b) fn,
  ) async {
    final b = CognitoAdminUpdateAuthEventFeedbackBuilder();
    fn(b);
    final req = b.build(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.execute();
  }
}
