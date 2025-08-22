import 'dart:convert';

/// Abstract interface for making authenticated HTTP requests to AWS Cognito.
///
/// Implementations of this interface must handle:
/// - Constructing the proper Cognito endpoint URL
/// - Signing requests with AWS SigV4 authentication
/// - Setting required Cognito-specific headers
/// - Sending JSON payloads via POST
///
/// This provides a consistent interface that can be implemented by different
/// HTTP client implementations while maintaining the required AWS Cognito
/// authentication and request formatting.
abstract class CognitoHttpClient {
  /// Makes a signed POST request to the Cognito service.
  ///
  /// Implementations must:
  /// 1. Resolve host to `https://cognito-idp.<region>.amazonaws.com`
  /// 2. Sign the request with SigV4 (service = 'cognito-idp')
  /// 3. Set required headers:
  ///    - `Content-Type: application/x-amz-json-1.1`
  ///    - `X-Amz-Target: [provided xAmzTarget]`
  /// 4. POST the JSON-encoded payload
  ///
  /// Parameters:
  /// - [region]: AWS region (e.g., 'us-east-1')
  /// - [xAmzTarget]: Cognito API target (e.g., 'AWSCognitoIdentityProviderService.AddCustomAttributes')
  /// - [payload]: Request payload to be JSON-encoded
  /// - [additionalHeaders]: Optional additional headers to include
  /// - [timeout]: Optional request timeout duration
  ///
  /// Returns a [Future] that completes with the HTTP response.
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  });

  /// Convenience method that matches the `send(...)` signature used by request classes.
  ///
  /// This provides a more generic interface that matches the style used by
  /// various request classes, while internally delegating to the [post] method.
  ///
  /// Parameters:
  /// - [service]: Ignored (always uses 'cognito-idp')
  /// - [target]: Cognito API target (maps to xAmzTarget)
  /// - [region]: AWS region
  /// - [payload]: Request payload
  /// - [timeout]: Request timeout
  /// - [headers]: Additional headers
  ///
  /// Returns a [Future] that completes with the HTTP response.
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) {
    // service is ignored here because this interface is only for Cognito
    return post(
      region: region,
      xAmzTarget: target,
      payload: payload,
      additionalHeaders: headers,
      timeout: timeout,
    );
  }
}

/// Represents an HTTP response from the Cognito service.
///
/// This is a lightweight wrapper around the raw HTTP response that provides
/// convenient access to the status code, headers, and body while maintaining
/// the original response data for error handling and debugging purposes.
class CognitoHttpResponse {
  /// The HTTP status code of the response.
  final int statusCode;

  /// The response headers as a map of string key-value pairs.
  final Map<String, String> headers;

  /// The raw response body as a string.
  ///
  /// This is kept as a raw string to preserve the original response for
  /// error propagation and debugging, even if JSON parsing fails.
  final String bodyString;

  /// Creates an HTTP response wrapper.
  ///
  /// Parameters:
  /// - [statusCode]: The HTTP status code
  /// - [headers]: The response headers
  /// - [bodyString]: The raw response body
  CognitoHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.bodyString,
  });

  /// The response body parsed as JSON, if possible.
  ///
  /// Returns:
  /// - A [Map] representing the JSON body if parsing succeeds
  /// - `null` if the body is empty or cannot be parsed as JSON
  Map<String, dynamic>? get jsonBody {
    try {
      if (bodyString.isEmpty) return null;
      return json.decode(bodyString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
