import 'cognito_main.dart';

/// Backwards-compatible public alias for the package's primary SDK client.
class CognitoAuth extends Cognito {
  /// Creates a [CognitoAuth] client with the shared [Cognito] constructor.
  CognitoAuth({required super.region, required super.httpClient});
}
