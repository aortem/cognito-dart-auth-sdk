import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';
import 'package:cognito_dart_auth_sdk/src/http_response.dart';

/// An abstract base class providing core authentication functionality.
///
/// This class serves as a foundation for classes that need to perform
/// authentication requests using cognito.
abstract class AuthBase {
  /// The [cognitoAuth] instance used to perform authentication requests.
  final cognitoAuth auth;

  /// Constructs an instance of [AuthBase].
  ///
  /// Parameters:
  /// - [auth]: The [cognitoAuth] instance that will handle requests.
  AuthBase(this.auth);

  /// Sends an authenticated request to cognito using the specified [endpoint]
  /// and request [body].
  ///
  /// Parameters:
  /// - [endpoint]: The cognito endpoint to interact with (e.g., 'update').
  /// - [body]: A `Map<String, dynamic>` containing the request payload.
  ///
  /// Returns a [Future] that resolves to an [HttpResponse] containing the
  /// server's response.
  ///
  /// Example usage:
  /// ```dart
  /// performRequest('update', {'oobCode': 'someCode'});
  /// ```
  Future<HttpResponse> performRequest(
      String endpoint, Map<String, dynamic> body) {
    return auth.performRequest(endpoint, body);
  }
}
