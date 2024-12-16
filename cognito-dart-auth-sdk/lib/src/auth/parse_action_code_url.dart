import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/http_response.dart';

import '../exceptions.dart';

/// A utility class for parsing action code URLs for cognito authentication.
///
/// This class provides a method to send a request to cognito Authentication's
/// backend service to parse an action code URL, which is typically used in email
/// action links (e.g., password reset, email verification, etc.).
///
/// The `parseActionCodeURL` method accepts an `oobCode` (out-of-band code) which
/// is included in action link URLs sent by cognito to the user. It communicates with
/// cognito backend to extract relevant information from the action code URL.
class cognitoParseUrlLink {
  /// cognito Authentication instance used for interacting with cognito Authentication.
  final cognitoAuth auth;

  /// Constructor for [cognitoParseUrlLink] class.
  ///
  /// Takes a [cognitoAuth] instance that is used to interact with cognito Authentication.
  ///
  /// - [auth]: An instance of [cognitoAuth] that handles communication with the cognito Authentication service.
  cognitoParseUrlLink({required this.auth});

  /// Parses an action code URL provided by cognito Authentication.
  ///
  /// The provided `oobCode` is the out-of-band code (a unique identifier) that is typically found
  /// in action link URLs sent to users for various authentication-related actions like email
  /// verification or password reset.
  ///
  /// This method sends a request to cognito's backend to parse the action code URL and return
  /// relevant information associated with that code.
  ///
  /// Returns an [HttpResponse] containing the parsed details of the action code URL.
  ///
  /// Throws [cognitoAuthException] if there is an error during the request process.
  Future<HttpResponse> parseActionCodeURL(String oobCode) async {
    try {
      // URL endpoint for parsing action code
      final url = 'parseCode';

      // Request body containing the oobCode
      final body = {
        'oobCode': oobCode,
      };

      // Send the request to cognito Authentication's backend service
      final response = await auth.performRequest(url, body);

      return response; // Returning the response, which should contain parsed URL details
    } catch (e) {
      print('Parse action code URL failed: $e');
      throw cognitoAuthException(
        code: 'parse-action-code-url-error',
        message: 'Failed to parse action code URL.',
      );
    }
  }
}
