import 'package:cognito_dart_auth_sdk/src/exceptions.dart';
import 'package:cognito_dart_auth_sdk/src/cognito_auth.dart';

/// Provides functionality to apply action codes (such as email verification
/// or password reset) within cognito.
class ApplyActionCode {
  /// The [cognitoAuth] instance used to interact with cognito for
  /// applying action codes.
  final cognitoAuth auth;

  /// Constructs an instance of [ApplyActionCode].
  ///
  /// Parameters:
  /// - [auth]: The [cognitoAuth] instance to be used for performing requests.
  ApplyActionCode(this.auth);

  /// Applies an action code in cognito, such as email verification or
  /// password reset.
  ///
  /// Parameters:
  /// - [actionCode]: The one-time code to be applied, as provided by cognito.
  ///
  /// Returns `true` if the action code was applied successfully, otherwise
  /// throws a [cognitoAuthException].
  ///
  /// Throws:
  /// - [cognitoAuthException] if the action code application fails.
  Future<bool> applyActionCode(String actionCode) async {
    try {
      await auth.performRequest(
        'update',
        {
          'oobCode': actionCode,
        },
      );
      return true;
    } catch (e) {
      print('Apply action code failed: $e');
      throw cognitoAuthException(
        code: 'apply-action-code-error',
        message: 'Failed to apply action code.',
      );
    }
  }
}
