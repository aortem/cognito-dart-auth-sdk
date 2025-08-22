import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_settings_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('   CognitoAdminSetUserSettingsRequest', () {
    test('toJson should return correct map', () {
      final request = CognitoAdminSetUserSettingsRequest(
        userPoolId: "us-east-1_123456789",
        username: "testuser",
        mfaOptions: [
          MFAOptionType(attributeName: "phone_number", deliveryMedium: "SMS"),
        ],
      );

      final json = request.toJson();

      expect(json["UserPoolId"], equals("us-east-1_123456789"));
      expect(json["Username"], equals("testuser"));
      expect(json["MFAOptions"], isA<List>());
      expect(json["MFAOptions"][0]["AttributeName"], equals("phone_number"));
      expect(json["MFAOptions"][0]["DeliveryMedium"], equals("SMS"));
    });
  });

  group('MFAOptionType', () {
    test('toJson should return correct map', () {
      final mfa = MFAOptionType(
        attributeName: "email",
        deliveryMedium: "EMAIL",
      );

      final json = mfa.toJson();

      expect(json["AttributeName"], equals("email"));
      expect(json["DeliveryMedium"], equals("EMAIL"));
    });
  });
}
