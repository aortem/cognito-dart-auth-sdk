import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_set_user_settings_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('   CognitoAdminSetUserSettingsResponse', () {
    test('fromJson should always return success', () {
      final response = CognitoAdminSetUserSettingsResponse.fromJson({});
      expect(response.success, isTrue);
    });

    test('default constructor should set success = true', () {
      final response = CognitoAdminSetUserSettingsResponse();
      expect(response.success, isTrue);
    });
  });

  group('Exceptions', () {
    test('InternalErrorException should have default message', () {
      final exception = InternalErrorException();
      expect(exception.message, contains("Internal error"));
    });

    test('InvalidParameterException should have default message', () {
      final exception = InvalidParameterException();
      expect(exception.message, contains("Invalid parameter"));
    });

    test('NotAuthorizedException should have default message', () {
      final exception = NotAuthorizedException();
      expect(exception.message, contains("Not authorized"));
    });

    test('ResourceNotFoundException should have default message', () {
      final exception = ResourceNotFoundException();
      expect(exception.message, contains("not found"));
    });

    test('UserNotFoundException should have default message', () {
      final exception = UserNotFoundException();
      expect(exception.message, contains("User not found"));
    });
  });
}
