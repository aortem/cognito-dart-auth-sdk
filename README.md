<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">cognito_dart_auth_sdk</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/cognito_dart_auth_sdk/tags">
  <img alt="Latest Release" src="https://img.shields.io/github/v/tag/aortem/cognito_dart_auth_sdk?style=for-the-badge" />
</a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/cognito_dart_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/cognito_dart_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- cognito Badge -->
   <a href="https://cognito.google.com/docs/reference/admin/node/cognito-admin.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<<<<<<< HEAD
=======
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/cognito_dart_auth_sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/cognito_dart_auth_sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
>>>>>>> main
</p>
<!-- x-hide-in-docs-start -->

### **Core Authentication Methods**

| Cognito Identity Provider Operation            | SDK API Method                             | Description                                                                                       |
|-----------------------------------------------|--------------------------------------------|---------------------------------------------------------------------------------------------------|
| AdminAddUserToGroup                           | `adminAddUserToGroup(...)`                 | Adds the specified user to the specified group.                                                   |
| AdminConfirmSignUp                            | `adminConfirmSignUp(...)`                  | Confirms user signup as an admin without requiring an email/SMS code.                             |
| AdminCreateUser                               | `adminCreateUser(...)`                     | Creates a new user in the user pool.                                                              |
| AdminDeleteUser                               | `adminDeleteUser(...)`                     | Deletes a user as an admin.                                                                       |
| AdminDisableUser                              | `adminDisableUser(...)`                    | Disables a user, preventing them from signing in.                                                 |
| AdminEnableUser                               | `adminEnableUser(...)`                     | Re-enables a disabled user.                                                                       |
| AdminForgetDevice                             | `adminForgetDevice(...)`                   | Forgets (removes) the device, requiring re-confirmation.                                          |
| AdminGetDevice                                | `adminGetDevice(...)`                      | Retrieves information about a user’s device.                                                      |
| AdminGetUser                                  | `adminGetUser(...)`                        | Retrieves user attributes, including custom attributes.                                           |
| AdminInitiateAuth                             | `adminInitiateAuth(...)`                   | Starts a custom authentication flow as an admin.                                                  |
| AdminListDevices                              | `adminListDevices(...)`                    | Lists a user’s devices.                                                                           |
| AdminListGroupsForUser                        | `adminListGroupsForUser(...)`              | Lists the groups the user belongs to.                                                             |
| AdminListUserAuthEvents                       | `adminListUserAuthEvents(...)`             | Returns authentication event history for a user.                                                  |
| AdminRemoveUserFromGroup                      | `adminRemoveUserFromGroup(...)`            | Removes a user from a group.                                                                      |
| AdminResetUserPassword                        | `adminResetUserPassword(...)`              | Sends a reset password email or SMS as an admin.                                                  |
| AdminRespondToAuthChallenge                   | `adminRespondToAuthChallenge(...)`         | Responds to an authentication challenge as an admin.                                              |
| AdminSetUserMFAPreference                     | `adminSetUserMFAPreference(...)`           | Sets MFA preferences for a user.                                                                  |
| AdminSetUserPassword                          | `adminSetUserPassword(...)`                | Sets a user’s password as an admin without sending a code.                                        |
| AdminSetUserSettings                          | `adminSetUserSettings(...)`                | Configures user settings, such as MFA on sign-in.                                                 |
| AdminUpdateAuthEventFeedback                  | `adminUpdateAuthEventFeedback(...)`        | Provides feedback on whether an authentication event was valid.                                   |
| AdminUpdateDeviceStatus                       | `adminUpdateDeviceStatus(...)`             | Updates the status of a user’s device (e.g., valid or revoked).                                   |
| AdminUpdateUserAttributes                     | `adminUpdateUserAttributes(...)`           | Updates the specified user attributes.                                                            |
| AdminUserGlobalSignOut                        | `adminUserGlobalSignOut(...)`              | Signs the user out from all devices.                                                              |
| AssociateSoftwareToken                        | `associateSoftwareToken(...)`              | Generates a TOTP secret and QR code for MFA.                                                      |
| ChangePassword                                | `changePassword(...)`                      | Changes the password for a signed-in user.                                                        |
| ConfirmDevice                                 | `confirmDevice(...)`                       | Confirms a device with a given confirmation code.                                                 |
| ConfirmForgotPassword                         | `confirmForgotPassword(...)`               | Confirms a password reset request with code and new password.                                      |
| ConfirmSignUp                                 | `confirmSignUp(...)`                       | Confirms user signup with the code sent via email/SMS.                                            |
| CreateGroup                                   | `createGroup(...)`                         | Creates a new group in the user pool.                                                             |
| CreateIdentityProvider                        | `createIdentityProvider(...)`              | Creates an identity provider for social or enterprise federation.                                 |
| CreateResourceServer                          | `createResourceServer(...)`                | Defines a set of scopes for custom resources.                                                     |
| CreateUserImportJob                           | `createUserImportJob(...)`                 | Starts a bulk user import job.                                                                    |
| CreateUserPool                                | `createUserPool(...)`                      | Creates a new user pool.                                                                          |
| CreateUserPoolClient                          | `createUserPoolClient(...)`                | Creates a new app client for the user pool.                                                       |
| CreateUserPoolDomain                          | `createUserPoolDomain(...)`                | Creates a custom domain for the user pool.                                                        |
| DeleteGroup                                   | `deleteGroup(...)`                         | Deletes the specified group.                                                                      |
| DeleteIdentityProvider                        | `deleteIdentityProvider(...)`              | Deletes an identity provider.                                                                     |
| DeleteResourceServer                          | `deleteResourceServer(...)`                | Deletes a resource server.                                                                        |
| DeleteUser                                    | `deleteUser(...)`                          | Deletes the currently authenticated user.                                                         |
| DeleteUserAttributes                          | `deleteUserAttributes(...)`                | Deletes specific user attributes.                                                                 |
| DeleteUserPool                                | `deleteUserPool(...)`                      | Deletes the user pool and all users.                                                              |
| DeleteUserPoolClient                          | `deleteUserPoolClient(...)`                | Deletes the user pool client.                                                                     |
| DeleteUserPoolDomain                          | `deleteUserPoolDomain(...)`                | Deletes the custom domain of the user pool.                                                       |
| DescribeIdentityProvider                      | `describeIdentityProvider(...)`            | Retrieves details of a specific identity provider.                                                |
| DescribeResourceServer                        | `describeResourceServer(...)`              | Retrieves settings for a resource server.                                                         |
| DescribeRiskConfiguration                     | `describeRiskConfiguration(...)`           | Retrieves risk configuration for adaptive authentication.                                         |
| DescribeUserImportJob                         | `describeUserImportJob(...)`               | Retrieves status of a bulk import job.                                                            |
| DescribeUserPool                              | `describeUserPool(...)`                    | Retrieves metadata about the user pool.                                                           |
| DescribeUserPoolClient                        | `describeUserPoolClient(...)`              | Retrieves settings for a user pool client.                                                       |
| DescribeUserPoolDomain                        | `describeUserPoolDomain(...)`              | Retrieves details of a custom domain.                                                             |
| ForgetDevice                                  | `forgetDevice(...)`                        | Forgets a device for the current user.                                                            |
| ForgotPassword                                | `forgotPassword(...)`                      | Initiates a forgot password flow by sending a code.                                               |
| GetCSVHeader                                  | `getCSVHeader(...)`                        | Retrieves the header information for a bulk import CSV file.                                      |
| GetDevice                                     | `getDevice(...)`                           | Retrieves device details for the current user.                                                    |
| GetGroup                                      | `getGroup(...)`                            | Retrieves details about a group.                                                                  |
| GetIdentityProviderByIdentifier               | `getIdentityProviderByIdentifier(...)`     | Retrieves a provider by its identifier.                                                           |
| GetSigningCertificate                         | `getSigningCertificate(...)`               | Retrieves the signing certificate for the user pool.                                             |
| GetUICustomization                            | `getUICustomization(...)`                  | Retrieves UI customization settings for the hosted UI.                                           |
| GetUser                                       | `getUser(...)`                             | Retrieves attributes for the currently authenticated user.                                       |
| GetUserAttributeVerificationCode              | `getUserAttributeVerificationCode(...)`    | Sends a verification code for a user attribute (email/phone).                                    |
| GetUserPoolMfaConfig                          | `getUserPoolMfaConfig(...)`                | Retrieves MFA configuration for the user pool.                                                   |
| GlobalSignOut                                 | `globalSignOut(...)`                       | Signs out the current user from all devices.                                                     |
| InitiateAuth                                  | `initiateAuth(...)`                        | Starts an authentication flow (e.g., USER_SRP_AUTH).                                             |
| ListDevices                                   | `listDevices(...)`                         | Lists devices for the current user.                                                               |
| ListGroups                                    | `listGroups(...)`                          | Lists groups in the user pool.                                                                    |
| ListIdentityProviders                         | `listIdentityProviders(...)`               | Lists all configured identity providers.                                                         |
| ListResourceServers                           | `listResourceServers(...)`                 | Lists resource servers for the user pool.                                                        |
| ListTagsForResource                           | `listTagsForResource(...)`                 | Lists the tags assigned to a resource.                                                           |
| ListUserImportJobs                            | `listUserImportJobs(...)`                  | Lists bulk import jobs.                                                                           |
| ListUserPoolClients                           | `listUserPoolClients(...)`                 | Lists app clients for the user pool.                                                              |
| ListUserPools                                 | `listUserPools(...)`                       | Lists user pools in the account.                                                                  |
| ListUsers                                     | `listUsers(...)`                           | Lists users in a user pool.                                                                       |
| ListUsersInGroup                              | `listUsersInGroup(...)`                    | Lists users in a specific group.                                                                  |
| ResendConfirmationCode                        | `resendConfirmationCode(...)`              | Resends the signup confirmation code to the user.                                                |
| RespondToAuthChallenge                        | `respondToAuthChallenge(...)`              | Responds to an authentication challenge (e.g., MFA).                                             |
| RevokeToken                                   | `revokeToken(...)`                         | Revokes a refresh token.                                                                          |
| SetRiskConfiguration                          | `setRiskConfiguration(...)`                | Sets adaptive authentication risk parameters.                                                    |
| SetUICustomization                            | `setUICustomization(...)`                  | Sets customization for the hosted UI.                                                            |
| SetUserMFAPreference                          | `setUserMFAPreference(...)`                | Sets MFA preferences for the user.                                                               |
| SetUserPoolMfaConfig                          | `setUserPoolMfaConfig(...)`                | Configures MFA at the pool level (e.g., SMS, TOTP).                                              |
| SetUserSettings                               | `setUserSettings(...)`                     | Sets user-level settings (e.g., MFA on sign-in).                                                 |
| SignUp                                        | `signUp(...)`                              | Registers a new user and sends a confirmation code.                                              |
| StopUserImportJob                             | `stopUserImportJob(...)`                   | Stops a bulk user import job.                                                                     |
| TagResource                                   | `tagResource(...)`                         | Adds tags to a Cognito resource.                                                                  |
| UntagResource                                 | `untagResource(...)`                       | Removes tags from a resource.                                                                     |
| UpdateAuthEventFeedback                       | `updateAuthEventFeedback(...)`             | Updates feedback (valid/invalid) for an auth event.                                              |
| UpdateDeviceStatus                            | `updateDeviceStatus(...)`                  | Updates a user’s device status (e.g., valid, blocked).                                           |
| UpdateGroup                                   | `updateGroup(...)`                         | Updates the name or description of a group.                                                      |
| UpdateIdentityProvider                        | `updateIdentityProvider(...)`              | Updates the configuration of an identity provider.                                               |
| UpdateResourceServer                          | `updateResourceServer(...)`                | Updates the scopes of a resource server.                                                         |
| UpdateUserAttributes                          | `updateUserAttributes(...)`                | Updates attributes for the current user.                                                         |
| UpdateUserPool                                | `updateUserPool(...)`                      | Updates attributes of the user pool.                                                             |
| UpdateUserPoolClient                          | `updateUserPoolClient(...)`                | Updates settings for an app client.                                                              |
| UpdateUserPoolDomain                          | `updateUserPoolDomain(...)`                | Updates the custom domain configuration.                                                         |
| VerifySoftwareToken                           | `verifySoftwareToken(...)`                 | Verifies a software token for TOTP-based MFA.                                                     |
| VerifyUserAttribute                           | `verifyUserAttribute(...)`                 | Verifies a user’s attribute (email/phone) with a code.                                           |
```

## Available Versions / Sample Apps

Cognito-Dart-Auth-SDK is available in a single version with sample apps:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.

2. **Sample Apps - FrontEnd Version**: The sample apps are provided in various frontend languages in order to allow maximum flexibility with your frontend implementation with the Dart backend.  Note that new features are first tested in the sample apps before being released in the mainline branch. Use only as a guide for your frontend/backend implementation of Dart.

- Access cognito Auth instance.
  ```
     final auth = cognitoApp.instance.getAuth();
  ```
## Documentation

For detailed guides, API references, and example projects, visit our [Cognito-Dart-Auth-SDK Documentation](https://aortem.gitbook.io/cognito-dart-auth-sdk). Start building with  Cognito-Dart-Auth-SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Cognito-Dart-Auth-SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Cognito-Dart-Auth-SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our [Support Page](https://aortem.io/support).


## Licensing

The **Cognito Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.

## Enhance with Cognito-Dart-Auth-SDK

We hope the Cognito-Dart-Auth-SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!
