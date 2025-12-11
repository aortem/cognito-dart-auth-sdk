// Ticket #54 - Issue   CognitoAdminSetUserSettingsRequest
// This action is deprecated (use AdminSetUserMFAPreference instead),
// but still implemented for compatibility.

/// [DEPRECATED] Request class for AdminSetUserSettings API operation.
///
/// ⚠️ This API action is deprecated by AWS Cognito.
/// Use [   CognitoAdminSetUserMFAPreferenceRequest] instead for setting
/// user MFA preferences.
///
/// This class is maintained only for backward compatibility with existing
/// systems that may still rely on this deprecated API endpoint.
///
/// The AdminSetUserSettings operation sets user settings for a specific user
/// in a user pool, primarily for MFA configuration.
///
/// Example (deprecated usage):
/// ```dart
/// final request =    CognitoAdminSetUserSettingsRequest(
///   userPoolId: 'us-west-2_EXAMPLE',
///   username: 'testuser',
///   mfaOptions: [
///     MFAOptionType(
///       attributeName: 'phone_number',
///       deliveryMedium: 'SMS',
///     ),
///   ],
/// );
/// ```
class CognitoAdminSetUserSettingsRequest {
  /// The ID of the user pool where the user exists.
  final String userPoolId;

  /// The username of the user whose settings are being configured.
  final String username;

  /// List of MFA options for the user.
  ///
  /// Specifies the MFA delivery methods and corresponding attributes
  /// that should be enabled for the user.
  final List<MFAOptionType> mfaOptions;

  /// Creates a new [DEPRECATED] AdminSetUserSettings request.
  ///
  /// Parameters:
  /// - [userPoolId]: Required - The Cognito User Pool ID
  /// - [username]: Required - The username of the user
  /// - [mfaOptions]: Required - List of MFA options to configure
  ///
  /// Note: This API is deprecated. Consider using AdminSetUserMFAPreference instead.
  CognitoAdminSetUserSettingsRequest({
    required this.userPoolId,
    required this.username,
    required this.mfaOptions,
  });

  /// Converts the request object to a JSON map for API serialization.
  ///
  /// Returns:
  /// A Map containing the request parameters formatted for the AWS Cognito API
  Map<String, dynamic> toJson() {
    return {
      "UserPoolId": userPoolId,
      "Username": username,
      "MFAOptions": mfaOptions.map((mfa) => mfa.toJson()).toList(),
    };
  }
}

/// Represents an MFA option type for deprecated AdminSetUserSettings API.
///
/// ⚠️ This class is part of the deprecated AdminSetUserSettings API.
/// Use the newer MFA preference APIs instead.
///
/// Defines how multi-factor authentication (MFA) should be delivered
/// to the user and which attribute should be used for that delivery method.
class MFAOptionType {
  /// The name of the attribute to use for MFA delivery.
  ///
  /// Common values:
  /// - 'phone_number': For SMS-based MFA
  /// - 'email': For email-based MFA
  final String attributeName;

  /// The delivery medium for the MFA code.
  ///
  /// Common values:
  /// - 'SMS': For SMS delivery
  /// - 'EMAIL': For email delivery
  final String deliveryMedium;

  /// Creates a new MFA option type for deprecated API usage.
  ///
  /// Parameters:
  /// - [attributeName]: Required - The attribute name for MFA delivery
  /// - [deliveryMedium]: Required - The delivery medium for MFA codes
  ///
  /// Note: Part of deprecated API. Use newer MFA preference methods instead.
  MFAOptionType({required this.attributeName, required this.deliveryMedium});

  /// Converts the MFA option to a JSON map for API serialization.
  ///
  /// Returns:
  /// A Map containing the MFA option parameters
  Map<String, dynamic> toJson() {
    return {"AttributeName": attributeName, "DeliveryMedium": deliveryMedium};
  }
}
