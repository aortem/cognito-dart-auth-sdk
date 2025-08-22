/// Main entry point for     Cognito SDK in Dart.
/// Provides high-level wrapper methods for Cognito operations.
library cognito_main;

import 'package:cognito_dart_auth_sdk/consumers/cognito_add_custom_attributes_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_add_user_to_group_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_confirm_sign_up_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_create_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_delete_user_attributes_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_delete_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_disable_provider_for_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_disable_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_enable_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_forget_device_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_get_device_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_get_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_initiate_auth_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_link_provider_for_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_devices_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_groups_for_user_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_groups_for_user_paginator_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_user_auth_events_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_reset_user_password_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_respond_to_auth_challenge_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_set_user_mfa_preference_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_set_user_password_consumer.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_update_auth_event_feedback_consumer.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_add_custom_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_add_user_to_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_confirm_sign_up_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_disable_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_disable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_enable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_initiate_auth_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_link_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_devices_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_user_auth_events_paginator_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_user_auth_events_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_reset_user_password_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_respond_to_auth_challenge_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_mfa_preference_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_set_user_password_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_update_auth_event_feedback_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

/// High-level     Cognito client.
///
/// This is the primary interface for interacting with AWS Cognito services.
/// It maintains shared configuration and exposes methods for all supported operations.
///
/// ## Features
/// - Manages AWS region configuration
/// - Handles HTTP client lifecycle
/// - Provides simplified methods for Cognito operations
/// - Implements consistent error handling
///
/// ## Example Usage
/// ```dart
/// final cognito =    Cognito(
///   region: 'us-east-1',
///   httpClient: myHttpClient,
/// );
/// ```
class Cognito {
  /// The AWS region where Cognito services are located (e.g., 'us-east-1')
  /// This is used to construct service endpoints
  final String region;

  /// The HTTP client implementation for making authenticated requests
  /// Must be configured with appropriate AWS credentials
  final CognitoHttpClient httpClient;

  /// Creates a new     Cognito client instance.
  ///
  /// @param region The AWS region identifier (required)
  /// @param httpClient Configured HTTP client (required)
  Cognito({required this.region, required this.httpClient});

  /// Adds custom attributes to a Cognito User Pool.
  ///
  /// This method allows extending the user schema with additional attributes.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param customAttributes List of attribute definitions to add
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAddCustomAttributesResult> addCustomAttributes({
    required String userPoolId,
    required List<CognitoSchemaAttributeType> customAttributes,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAddCustomAttributesRequest(
      userPoolId: userPoolId,
      region: region,
      httpClient: httpClient,
      customAttributes: customAttributes,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  /// Adds custom attributes using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for defining attributes with runtime validation.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param consumer Builder function that defines attributes
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.addCustomAttributesWith(
  ///   userPoolId: 'us-east-1_abc123',
  ///   consumer: (b) => b
  ///     .string(name: 'custom:department', minLength: '1', maxLength: '255')
  ///     .number(name: 'custom:security_level', minValue: '1', maxValue: '10'),
  /// );
  /// ```
  Future<CognitoAddCustomAttributesResult> addCustomAttributesWith({
    required String userPoolId,
    required CognitoAttributesConsumer consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAddCustomAttributesConsumer(
      userPoolId: userPoolId,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Adds an existing user to a Cognito group using admin privileges.
  ///
  /// Requires appropriate IAM permissions for the cognito-idp:AdminAddUserToGroup action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param username The user to add to the group
  /// @param groupName The target group name
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminAddUserToGroupResult> adminAddUserToGroup({
    required String userPoolId,
    required String username,
    required String groupName,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminAddUserToGroupRequest(
      userPoolId: userPoolId,
      username: username,
      groupName: groupName,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  /// Adds a user to a group using consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param consumer Builder function that configures the operation
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminAddUserToGroupWith(
  ///   userPoolId: 'us-east-1_abc123',
  ///   consumer: (b) => b
  ///     .username('service.account')
  ///     .groupName('Administrators'),
  /// );
  /// ```
  Future<CognitoAdminAddUserToGroupResult> adminAddUserToGroupWith({
    required String userPoolId,
    required void Function(CognitoAdminAddUserToGroupBuilder) consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminAddUserToGroupConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run((b) => b.userPoolId(userPoolId));
  }

  //
  // New AdminConfirmSignUp methods
  //
  // --------------------------------------------------------------------------------
  /// Confirms a user's sign-up as an administrator.
  ///
  /// Requires appropriate IAM permissions for the cognito-idp:AdminConfirmSignUp action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param username The user to confirm
  /// @param clientMetadata Optional map of client-side metadata
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminConfirmSignUpResult> adminConfirmSignUp({
    required String userPoolId,
    required String username,
    Map<String, String>? clientMetadata,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminConfirmSignUpRequest(
      userPoolId: userPoolId,
      username: username,
      clientMetadata: clientMetadata,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Confirms a user's sign-up using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminConfirmSignUpWith(
  ///   (b) => b
  ///     .userPoolId('us-east-1_abc123')
  ///     .username('jane.doe@example.com'),
  /// );
  /// ```
  Future<CognitoAdminConfirmSignUpResult> adminConfirmSignUpWith({
    required CognitoConfirmSignUpConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminConfirmSignUpConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminCreateUser methods
  //
  // --------------------------------------------------------------------------------
  /// Creates a new user in the specified Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the cognito-idp:AdminCreateUser action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param username The username for the new user
  /// @param userAttributes A list of name/value pairs for user attributes
  /// @param desiredDeliveryMediums A list of delivery mediums for the invitation message
  /// @param forceAliasCreation Whether to force alias creation
  /// @param messageAction Action to take regarding the invitation message
  /// @param temporaryPassword A temporary password for the user
  /// @param clientMetadata Optional map of client-side metadata
  /// @param validationData A list of temporary attributes for pre sign-up triggers
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminCreateUserResult> adminCreateUser({
    required String userPoolId,
    required String username,
    List<CognitoAttributeType>? userAttributes,
    List<String>? desiredDeliveryMediums,
    bool? forceAliasCreation,
    CognitoMessageActionType? messageAction,
    String? temporaryPassword,
    Map<String, String>? clientMetadata,
    List<CognitoAttributeType>? validationData,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminCreateUserRequest(
      userPoolId: userPoolId,
      username: username,
      userAttributes: userAttributes,
      desiredDeliveryMediums: desiredDeliveryMediums,
      forceAliasCreation: forceAliasCreation,
      messageAction: messageAction,
      temporaryPassword: temporaryPassword,
      clientMetadata: clientMetadata,
      validationData: validationData,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Creates a new user using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for defining user parameters with runtime validation.
  ///
  /// @param consumer Builder function that configures the operation
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminCreateUserWith(
  ///   (b) => b
  ///     .userPoolId('us-east-1_abc123')
  ///     .username('jane.doe@example.com')
  ///     .email('jane.doe@example.com')
  ///     .deliveryEmail()
  ///     .messageSuppress(),
  /// );
  /// ```
  Future<CognitoAdminCreateUserResult> adminCreateUserWith({
    required CognitoCreateUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminCreateUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminDeleteUser methods
  //
  // --------------------------------------------------------------------------------
  /// Deletes a user from the specified Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the cognito-idp:AdminDeleteUser action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param username The user to delete
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result (no data on success)
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminDeleteUserResult> adminDeleteUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminDeleteUserRequest(
      userPoolId: userPoolId,
      username: username,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Deletes a user using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result (no data on success)
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminDeleteUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.delete@example.com'),
  /// );
  /// ```
  Future<CognitoAdminDeleteUserResult> adminDeleteUserWith({
    required CognitoDeleteUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminDeleteUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Deletes selected attributes from a user in the specified Cognito user pool.
  ///
  /// Requires appropriate IAM permissions for the cognito-idp:AdminDeleteUserAttributes action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param username The username of the user whose attributes will be deleted
  /// @param userAttributeNames List of attribute names to delete (standard or custom attributes)
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result (no data on success)
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  Future<CognitoAdminDeleteUserAttributesResult> adminDeleteUserAttributes({
    required String userPoolId,
    required String username,
    required List<String> userAttributeNames,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminDeleteUserAttributesRequest(
      userPoolId: userPoolId,
      username: username,
      userAttributeNames: userAttributeNames,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Deletes user attributes using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation
  /// @param maxRetries Maximum retry attempts (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result (no data on success)
  /// @throws    CognitoValidationException for invalid parameters
  /// @throws    CognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminDeleteUserAttributesWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.modify@example.com')
  ///      .attribute('custom:old_data')
  ///      .attributes(['address', 'phone_number']),
  /// );
  /// ```
  Future<CognitoAdminDeleteUserAttributesResult> adminDeleteUserAttributesWith({
    required CognitoDeleteUserAttrsConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminDeleteUserAttributesConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Prevents a user from signing in with a specific identity provider (IdP).
  ///
  /// This operation links the user to a specific IdP and marks that IdP
  /// as disabled for the user within the specified user pool.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminDisableProviderForUser` action.
  ///
  /// @param userPoolId The ID of the user pool.
  /// @param providerName The name of the identity provider.
  /// @param providerAttributeName The name of the provider attribute (e.g., 'Cognito_Subject').
  /// @param providerAttributeValue The value of the provider attribute.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminDisableProviderForUserResult> adminDisableProviderForUser({
    required String userPoolId,
    required String providerName,
    required String providerAttributeName,
    required String providerAttributeValue,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final userIdentifier = CognitoProviderUserIdentifier(
      providerName: providerName,
      providerAttributeName: providerAttributeName,
      providerAttributeValue: providerAttributeValue,
    );

    final req = CognitoAdminDisableProviderForUserRequest(
      userPoolId: userPoolId,
      user: userIdentifier,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  /// Prevents a user from signing in with a specific IdP using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminDisableProviderForUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .providerName('Google')
  ///      .providerAttributeName('Cognito_Subject')
  ///      .providerAttributeValue('google-subject-id-123'),
  /// );
  /// ```
  Future<CognitoAdminDisableProviderForUserResult>
  adminDisableProviderForUserWith({
    required CognitoDisableProviderConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminDisableProviderForUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Deactivates a user in a Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminDisableUser` action.
  /// This action prevents the user from signing in, but does not delete the user profile.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user to deactivate.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminDisableUserResult> adminDisableUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminDisableUserRequest(
      userPoolId: userPoolId,
      username: username,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Deactivates a user in a Cognito user pool using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminDisableUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.disable@example.com'),
  /// );
  /// ```
  Future<CognitoAdminDisableUserResult> adminDisableUserWith({
    required CognitoDisableUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminDisableUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Re-activates a user in a Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminEnableUser` action.
  /// This action changes the user's status to ENABLED, allowing them to sign in again.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user to reactivate.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminEnableUserResult> adminEnableUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminEnableUserRequest(
      userPoolId: userPoolId,
      username: username,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Re-activates a user in a Cognito user pool using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminEnableUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.enable@example.com'),
  /// );
  /// ```
  Future<CognitoAdminEnableUserResult> adminEnableUserWith({
    required CognitoEnableUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminEnableUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Deletes a remembered device for a user in a Cognito user pool as an administrator.
  ///
  /// This action removes the association between a user and a specific device,
  /// preventing that device from being recognized for future sign-ins or MFA.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminForgetDevice` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose device will be forgotten.
  /// @param deviceKey The unique identifier of the device to forget.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminForgetDeviceResult> adminForgetDevice({
    required String userPoolId,
    required String username,
    required String deviceKey,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminForgetDeviceRequest(
      userPoolId: userPoolId,
      username: username,
      deviceKey: deviceKey,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Deletes a remembered device for a user using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminForgetDeviceWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.with.device@example.com')
  ///      .deviceKey('some-device-key-uuid'),
  /// );
  /// ```
  Future<CognitoAdminForgetDeviceResult> adminForgetDeviceWith({
    required CognitoForgetDeviceConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminForgetDeviceConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  /// Returns details for a user's remembered device as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminGetDevice` action.
  /// This retrieves information about a specific device associated with a user in a user pool.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user who owns the device.
  /// @param deviceKey The unique identifier of the device.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminGetDeviceResult] containing device details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminGetDeviceResult> adminGetDevice({
    required String userPoolId,
    required String username,
    required String deviceKey,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminGetDeviceRequest(
      userPoolId: userPoolId,
      username: username,
      deviceKey: deviceKey,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Returns details for a user's remembered device using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminGetDeviceResult] containing device details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminGetDeviceWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.with.device@example.com')
  ///      .deviceKey('some-device-key-uuid'),
  /// );
  /// ```
  Future<CognitoAdminGetDeviceResult> adminGetDeviceWith({
    required CognitoGetDeviceConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminGetDeviceConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminGetUser methods
  //
  // --------------------------------------------------------------------------------
  /// Retrieves detailed information about a user profile in a Cognito user pool.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminGetUser` action.
  /// This operation fetches comprehensive details about a user, including attributes,
  /// MFA settings, and account status.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user to retrieve.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminGetUserResult] containing user details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminGetUserResult> adminGetUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminGetUserRequest(
      userPoolId: userPoolId,
      username: username,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Retrieves detailed user information using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminGetUserResult] containing user details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminGetUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.query@example.com'),
  /// );
  /// ```
  Future<CognitoAdminGetUserResult> adminGetUserWith({
    required CognitoGetUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminGetUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminInitiateAuth methods
  //
  // --------------------------------------------------------------------------------
  /// Starts a server-side authentication flow for an app client as an administrator.
  ///
  /// This operation initiates the authentication process, which may involve
  /// returning tokens directly or presenting a challenge (e.g., MFA, new password).
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminInitiateAuth` action.
  ///
  /// @param userPoolId The ID of the user pool.
  /// @param clientId The ID of the app client.
  /// @param authFlow The authentication flow to use (e.g., 'ADMIN_USER_PASSWORD_AUTH').
  /// @param authParameters A map of authentication parameters (e.g., 'USERNAME', 'PASSWORD').
  /// @param clientMetadata Optional map of client-side metadata.
  /// @param contextData Optional map of context data for Lambda triggers.
  /// @param analyticsMetadata Optional map of analytics metadata.
  /// @param session Optional session string from a previous challenge.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminInitiateAuthResult] with tokens or challenge details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminInitiateAuthResult> adminInitiateAuth({
    required String userPoolId,
    required String clientId,
    required String authFlow,
    required Map<String, String> authParameters,
    Map<String, String>? clientMetadata,
    Map<String, dynamic>? contextData,
    Map<String, dynamic>? analyticsMetadata,
    String? session,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminInitiateAuthRequest(
      userPoolId: userPoolId,
      clientId: clientId,
      authFlow: authFlow,
      authParameters: authParameters,
      clientMetadata: clientMetadata,
      contextData: contextData,

      session: session,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Starts a server-side authentication flow using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring authentication parameters.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminInitiateAuthResult] with tokens or challenge details.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminInitiateAuthWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .clientId('app-client-id')
  ///      .authFlow('ADMIN_USER_PASSWORD_AUTH')
  ///      .authParameters({'USERNAME': 'testuser', 'PASSWORD': 'Password!234'}),
  /// );
  /// ```
  Future<CognitoAdminInitiateAuthResult> adminInitiateAuthWith({
    required CognitoAdminInitiateAuthConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminInitiateAuthConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminLinkProviderForUser methods
  //
  // --------------------------------------------------------------------------------
  /// Links an external identity provider (IdP) identity to an existing user in a Cognito user pool.
  ///
  /// This operation allows administrators to associate a user from an external IdP
  /// (SourceUser) with an existing user in the user pool (DestinationUser).
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminLinkProviderForUser` action.
  ///
  /// @param userPoolId The ID of the user pool.
  /// @param destinationUser The existing user in the user pool to link to.
  /// @param sourceUser The external IdP identity to link.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminLinkProviderForUserResult> adminLinkProviderForUser({
    required String userPoolId,
    required CognitoProviderUserLinkingIdentifier destinationUser,
    required CognitoProviderUserLinkingIdentifier sourceUser,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminLinkProviderForUserRequest(
      userPoolId: userPoolId,
      destinationUser: destinationUser,
      sourceUser: sourceUser,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Links an external IdP identity to an existing user using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring the linking operation.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminLinkProviderForUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .destinationUser(
  ///        providerName: 'Cognito',
  ///        providerAttributeValue: 'local-username',
  ///      )
  ///      .sourceUser(
  ///        providerName: 'Google',
  ///        providerAttributeName: 'Cognito_Subject',
  ///        providerAttributeValue: 'google-subject-id',
  ///      ),
  /// );
  /// ```
  Future<CognitoAdminLinkProviderForUserResult> adminLinkProviderForUserWith({
    required CognitoAdminLinkProviderForUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminLinkProviderForUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminListDevices methods
  //
  // --------------------------------------------------------------------------------
  /// Lists a user's remembered devices in a Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListDevices` action.
  /// This operation retrieves a paginated list of devices associated with a user.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose devices are to be listed.
  /// @param limit Optional: The maximum number of results to be returned (0-60).
  /// @param paginationToken Optional: An opaque pagination token for fetching the next page.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminListDevicesResult] containing device list and pagination token.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminListDevicesResult> adminListDevices({
    required String userPoolId,
    required String username,
    int? limit,
    String? paginationToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminListDevicesRequest(
      userPoolId: userPoolId,
      username: username,
      limit: limit,
      paginationToken: paginationToken,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Lists a user's remembered devices using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminListDevicesResult] containing device list and pagination token.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminListDevicesWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.list.devices@example.com')
  ///      .limit(10),
  /// );
  /// ```
  Future<CognitoAdminListDevicesResult> adminListDevicesWith({
    required CognitoAdminListDevicesConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminListDevicesConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminListGroupsForUser methods
  //
  // --------------------------------------------------------------------------------
  /// Lists the groups that a user belongs to in a Cognito user pool as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListGroupsForUser` action.
  /// This operation retrieves a paginated list of groups associated with a user.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose groups are to be listed.
  /// @param limit Optional: The maximum number of results to be returned (0-60).
  /// @param nextToken Optional: An opaque pagination token for fetching the next page.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminListGroupsForUserResult> adminListGroupsForUser({
    required String userPoolId,
    required String username,
    int? limit,
    String? nextToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminListGroupsForUserRequest(
      userPoolId: userPoolId,
      username: username,
      limit: limit,
      nextToken: nextToken,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Lists the groups a user belongs to using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminListGroupsForUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.in.groups@example.com')
  ///      .limit(5),
  /// );
  /// ```
  Future<CognitoAdminListGroupsForUserResult> adminListGroupsForUserWith({
    required CognitoAdminListGroupsForUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminListGroupsForUserConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminListGroupsForUserPaginator method
  //
  // --------------------------------------------------------------------------------
  /// Returns a paginator for listing the groups that a user belongs to.
  ///
  /// This paginator allows fetching all groups or iterating page by page.
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListGroupsForUser` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose groups are to be listed.
  /// @param limit Optional: The maximum number of results per page (0-60).
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return An instance of [   CognitoAdminListGroupsForUserPaginatorRequest].
  /// @throws    CognitoValidationException for invalid parameters.

  // //
  // --------------------------------------------------------------------------------
  // Returns a paginator for listing the groups that a user belongs to.
  ///
  /// This paginator allows fetching all groups or iterating page by page.
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListGroupsForUser` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose groups are to be listed.
  /// @param limit Optional: The maximum number of results per page (0-60).
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return An instance of [   CognitoAdminListGroupsForUserPaginatorConsumer].
  /// @throws    CognitoValidationException for invalid parameters.
  CognitoAdminListGroupsForUserPaginatorConsumer
  adminListGroupsForUserPaginator({
    required String userPoolId,
    required String username,
    int? limit,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return CognitoAdminListGroupsForUserPaginatorConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    ); // Set initial values
  }

  // New AdminListUserAuthEventsPaginator methods
  //
  // --------------------------------------------------------------------------------
  /// Returns a paginator for listing a user's authentication events and risk signals.
  ///
  /// This paginator allows fetching all events or iterating page by page.
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListUserAuthEvents` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user to query.
  /// @param maxResults Optional: The maximum number of results to be returned per page (0-60).
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return An instance of [   CognitoAdminListUserAuthEventsPaginatorRequest].
  /// @throws    CognitoValidationException for invalid parameters.
  CognitoAdminListUserAuthEventsPaginatorRequest
  adminListUserAuthEventsPaginator({
    required String userPoolId,
    required String username,
    int? maxResults,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return CognitoAdminListUserAuthEventsPaginatorRequest(
      userPoolId: userPoolId,
      username: username,

      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
  }

  //
  // Existing AdminListUserAuthEvents methods
  //
  // --------------------------------------------------------------------------------
  /// Returns a history of user authentication events and associated risk scores as an administrator.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminListUserAuthEvents` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user to query.
  /// @param maxResults Optional: The maximum number of results to be returned per page (0-60).
  /// @param nextToken Optional: An opaque pagination token for fetching the next page.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to a list of all authentication events across all pages.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<List<Map<String, dynamic>>> adminListUserAuthEvents({
    required String userPoolId,
    required String username,
    int? maxResults,
    String? nextToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminListUserAuthEventsRequest(
      userPoolId: userPoolId,
      username: username,
      maxResults: maxResults,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await req.listAll();
  }

  // --------------------------------------------------------------------------------
  /// Returns a paginator for listing user authentication events.
  ///
  /// This paginator allows iterating page by page or fetching all events at once.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return An instance of [   CognitoAdminListUserAuthEventsConsumer].
  /// @throws    CognitoValidationException for invalid parameters.
  CognitoAdminListUserAuthEventsConsumer adminListUserAuthEventsWith({
    required CognitoAdminListUserAuthEventsFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    final c = CognitoAdminListUserAuthEventsConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return c..runAll(consumer);
  }

  // New AdminResetUserPassword methods
  //
  // --------------------------------------------------------------------------------
  /// Begins a password reset for a user in a Cognito user pool as an administrator.
  ///
  /// This operation initiates the password reset flow, typically sending a
  /// verification code via email or SMS.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminResetUserPassword` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose password will be reset.
  /// @param clientMetadata Optional map of client-side metadata.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminResetUserPasswordResult> adminResetUserPassword({
    required String userPoolId,
    required String username,
    Map<String, String>? clientMetadata,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminResetUserPasswordRequest(
      userPoolId: userPoolId,
      username: username,
      clientMetadata: clientMetadata,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Begins a password reset for a user using a consumer/builder pattern.
  ///
  /// Provides input normalization and validation before execution.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminResetUserPasswordWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.reset@example.com')
  ///      .clientMetadata({'source': 'admin-panel'}),
  /// );
  /// ```
  Future<CognitoAdminResetUserPasswordResult> adminResetUserPasswordWith({
    required CognitoAdminResetUserPasswordFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminResetUserPasswordConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  //
  // New AdminRespondToAuthChallenge methods
  //
  // --------------------------------------------------------------------------------
  /// Responds to an authentication challenge from Cognito as an administrator.
  ///
  /// This operation is used to complete authentication flows that require
  /// additional steps, such as MFA challenges, new password requirements,
  /// or custom authentication challenges.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminRespondToAuthChallenge` action.
  ///
  /// @param userPoolId The ID of the user pool.
  /// @param clientId The ID of the app client.
  /// @param challengeName The name of the challenge (e.g., 'SMS_MFA', 'NEW_PASSWORD_REQUIRED').
  /// @param challengeResponses A map of challenge response parameters.
  /// @param clientMetadata Optional map of client-side metadata.
  /// @param analyticsMetadata Optional map of analytics metadata.
  /// @param contextData Optional map of context data.
  /// @param session Optional session string from the previous challenge.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminRespondToAuthChallengeResult] with raw response body and status.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminRespondToAuthChallengeResult> adminRespondToAuthChallenge({
    required String userPoolId,
    required String clientId,
    required String challengeName,
    required Map<String, String> challengeResponses,
    Map<String, String>? clientMetadata,
    Map<String, dynamic>? analyticsMetadata,
    Map<String, dynamic>? contextData,
    String? session,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminRespondToAuthChallengeRequest(
      userPoolId: userPoolId,
      clientId: clientId,
      challengeName: challengeName,
      challengeResponses: challengeResponses,
      clientMetadata: clientMetadata,
      analyticsMetadata: analyticsMetadata,
      contextData: contextData,
      session: session,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Responds to an authentication challenge using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring challenge responses.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminRespondToAuthChallengeResult] with raw response body and status.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminRespondToAuthChallengeWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .clientId('app-client-id')
  ///      .challengeName('SMS_MFA')
  ///      .challengeResponses({'USERNAME': 'testuser', 'SMS_MFA_CODE': '123456'})
  ///      .session('session-token-from-initiate-auth'),
  /// );
  /// ```
  Future<CognitoAdminRespondToAuthChallengeResult>
  adminRespondToAuthChallengeWith({
    required CognitoAdminRespondToAuthChallengeFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminRespondToAuthChallengeConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  // New AdminSetUserMFAPreference methods
  //
  // --------------------------------------------------------------------------------
  /// Sets the MFA preference for a user in a Cognito user pool as an administrator.
  ///
  /// This operation allows enabling or disabling specific MFA methods (SMS, Email, Software Token)
  /// and setting a preferred MFA method for a user.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminSetUserMFAPreference` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose MFA preference will be set.
  /// @param emailMfaSettings Optional map for email MFA settings (e.g., `{'Enabled': true}`).
  /// @param smsMfaSettings Optional map for SMS MFA settings (e.g., `{'Enabled': true}`).
  /// @param softwareTokenMfaSettings Optional map for software token MFA settings (e.g., `{'Enabled': true}`).
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminSetUserMFAPreferenceResult] with raw response JSON.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminSetUserMFAPreferenceResult> adminSetUserMFAPreference({
    required String userPoolId,
    required String username,
    Map<String, dynamic>? emailMfaSettings,
    Map<String, dynamic>? smsMfaSettings,
    Map<String, dynamic>? softwareTokenMfaSettings,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminSetUserMFAPreferenceRequest(
      userPoolId: userPoolId,
      username: username,
      emailMfaSettings: emailMfaSettings,
      smsMfaSettings: smsMfaSettings,
      softwareTokenMfaSettings: softwareTokenMfaSettings,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Sets the MFA preference for a user using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring MFA settings.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to [   CognitoAdminSetUserMFAPreferenceResult] with raw response JSON.
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminSetUserMFAPreferenceWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.mfa@example.com')
  ///      .smsMfaSettings({'Enabled': true, 'PreferredMfa': true})
  ///      .emailMfaSettings({'Enabled': false}),
  /// );
  /// ```
  Future<CognitoAdminSetUserMFAPreferenceResult> adminSetUserMFAPreferenceWith({
    required CognitoAdminSetUserMFAPreferenceFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminSetUserMFAPreferenceConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  //
  // New AdminSetUserPassword methods
  //
  // --------------------------------------------------------------------------------
  /// Sets a user's password in a Cognito user pool as an administrator.
  ///
  /// This operation can be used to set a new password for a user,
  /// optionally making it permanent.
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminSetUserPassword` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user whose password will be set.
  /// @param password The new password for the user.
  /// @param permanent Optional: Whether the password is permanent (true) or temporary (false).
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminSetUserPasswordResult> adminSetUserPassword({
    required String userPoolId,
    required String username,
    required String password,
    bool? permanent,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminSetUserPasswordRequest(
      userPoolId: userPoolId,
      username: username,
      password: password,
      permanent: permanent,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  // --------------------------------------------------------------------------------
  /// Sets a user's password using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring the password setting operation.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminSetUserPasswordWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.set.password@example.com')
  ///      .password('NewSecurePassword!1')
  ///      .permanent(true),
  /// );
  /// ```
  Future<CognitoAdminSetUserPasswordResult> adminSetUserPasswordWith({
    required CognitoAdminSetUserPasswordFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminSetUserPasswordConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  //
  // New AdminUpdateAuthEventFeedback methods
  //
  // --------------------------------------------------------------------------------
  /// Provides feedback on an authentication event for risk-based adaptive authentication.
  ///
  /// This operation allows administrators to mark an authentication event as either
  /// legitimate ('Valid') or fraudulent ('Invalid').
  ///
  /// Requires appropriate IAM permissions for the `cognito-idp:AdminUpdateAuthEventFeedback` action.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID).
  /// @param username The username of the user associated with the event.
  /// @param eventId The unique identifier of the authentication event.
  /// @param feedbackValue The feedback value, either 'Valid' or 'Invalid'.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminUpdateAuthEventFeedbackResult>
  adminUpdateAuthEventFeedback({
    required String userPoolId,
    required String username,
    required String eventId,
    required String feedbackValue,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = CognitoAdminUpdateAuthEventFeedbackRequest(
      userPoolId: userPoolId,
      username: username,
      eventId: eventId,
      feedbackValue: feedbackValue,
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );

    return await req.execute();
  }

  /// Provides feedback on an authentication event using a consumer/builder pattern.
  ///
  /// Provides a fluent interface for configuring the feedback operation.
  ///
  /// @param consumer Builder function that configures the operation.
  /// @param maxRetries Maximum retry attempts (default: 2).
  /// @param requestTimeout Duration before request times out (default: 20s).
  /// @return Future resolving to operation result (no data on success).
  /// @throws    CognitoValidationException for invalid parameters.
  /// @throws    CognitoServiceException for API failures.
  Future<CognitoAdminUpdateAuthEventFeedbackResult>
  adminUpdateAuthEventFeedbackWith({
    required CognitoAdminUpdateAuthEventFeedbackConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = CognitoAdminUpdateAuthEventFeedbackConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    );
    return await c.run(consumer);
  }

  //
}
