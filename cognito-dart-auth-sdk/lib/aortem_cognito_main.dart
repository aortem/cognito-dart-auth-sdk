/// Main entry point for Aortem Cognito SDK in Dart.
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
import 'package:cognito_dart_auth_sdk/requests/cognito_add_custom_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_add_user_to_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_confirm_sign_up_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_delete_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_disable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_enable_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_forget_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_device_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_initiate_auth_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_link_provider_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_devices_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_paginator_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

import 'requests/cognito_admin_disable_provider_for_user_request.dart';

/// High-level Aortem Cognito client.
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
/// final cognito = AortemCognito(
///   region: 'us-east-1',
///   httpClient: myHttpClient,
/// );
/// ```
class AortemCognito {
  /// The AWS region where Cognito services are located (e.g., 'us-east-1')
  /// This is used to construct service endpoints
  final String region;

  /// The HTTP client implementation for making authenticated requests
  /// Must be configured with appropriate AWS credentials
  final AortemCognitoHttpClient httpClient;

  /// Creates a new Aortem Cognito client instance.
  ///
  /// @param region The AWS region identifier (required)
  /// @param httpClient Configured HTTP client (required)
  AortemCognito({required this.region, required this.httpClient});

  /// Adds custom attributes to a Cognito User Pool.
  ///
  /// This method allows extending the user schema with additional attributes.
  ///
  /// @param userPoolId The target user pool ID (format: region_ID)
  /// @param customAttributes List of attribute definitions to add
  /// @param maxRetries Maximum retry attempts for failed requests (default: 2)
  /// @param requestTimeout Duration before request times out (default: 20s)
  /// @return Future resolving to operation result
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAddCustomAttributesResult> addCustomAttributes({
    required String userPoolId,
    required List<AortemCognitoSchemaAttributeType> customAttributes,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAddCustomAttributesRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
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
  Future<AortemCognitoAddCustomAttributesResult> addCustomAttributesWith({
    required String userPoolId,
    required AortemCognitoAttributesConsumer consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAddCustomAttributesConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminAddUserToGroupResult> adminAddUserToGroup({
    required String userPoolId,
    required String username,
    required String groupName,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminAddUserToGroupRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
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
  Future<AortemCognitoAdminAddUserToGroupResult> adminAddUserToGroupWith({
    required String userPoolId,
    required void Function(AortemCognitoAdminAddUserToGroupBuilder) consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminAddUserToGroupConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminConfirmSignUpResult> adminConfirmSignUp({
    required String userPoolId,
    required String username,
    Map<String, String>? clientMetadata,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminConfirmSignUpRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminConfirmSignUpWith(
  ///   (b) => b
  ///     .userPoolId('us-east-1_abc123')
  ///     .username('jane.doe@example.com'),
  /// );
  /// ```
  Future<AortemCognitoAdminConfirmSignUpResult> adminConfirmSignUpWith({
    required AortemCognitoConfirmSignUpConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminConfirmSignUpConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminCreateUserResult> adminCreateUser({
    required String userPoolId,
    required String username,
    List<AortemCognitoAttributeType>? userAttributes,
    List<String>? desiredDeliveryMediums,
    bool? forceAliasCreation,
    AortemCognitoMessageActionType? messageAction,
    String? temporaryPassword,
    Map<String, String>? clientMetadata,
    List<AortemCognitoAttributeType>? validationData,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminCreateUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
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
  Future<AortemCognitoAdminCreateUserResult> adminCreateUserWith({
    required AortemCognitoCreateUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminCreateUserConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminDeleteUserResult> adminDeleteUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminDeleteUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  ///
  /// Example:
  /// ```dart
  /// await client.adminDeleteUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.delete@example.com'),
  /// );
  /// ```
  Future<AortemCognitoAdminDeleteUserResult> adminDeleteUserWith({
    required AortemCognitoDeleteUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminDeleteUserConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
  Future<AortemCognitoAdminDeleteUserAttributesResult>
  adminDeleteUserAttributes({
    required String userPoolId,
    required String username,
    required List<String> userAttributeNames,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminDeleteUserAttributesRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters
  /// @throws AortemCognitoServiceException for API failures
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
  Future<AortemCognitoAdminDeleteUserAttributesResult>
  adminDeleteUserAttributesWith({
    required AortemCognitoDeleteUserAttrsConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminDeleteUserAttributesConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminDisableProviderForUserResult>
  adminDisableProviderForUser({
    required String userPoolId,
    required String providerName,
    required String providerAttributeName,
    required String providerAttributeValue,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final userIdentifier = AortemCognitoProviderUserIdentifier(
      providerName: providerName,
      providerAttributeName: providerAttributeName,
      providerAttributeValue: providerAttributeValue,
    );

    final req = AortemCognitoAdminDisableProviderForUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminDisableProviderForUserResult>
  adminDisableProviderForUserWith({
    required AortemCognitoDisableProviderConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminDisableProviderForUserConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminDisableUserResult> adminDisableUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminDisableUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminDisableUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.disable@example.com'),
  /// );
  /// ```
  Future<AortemCognitoAdminDisableUserResult> adminDisableUserWith({
    required AortemCognitoDisableUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminDisableUserConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminEnableUserResult> adminEnableUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminEnableUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminEnableUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.enable@example.com'),
  /// );
  /// ```
  Future<AortemCognitoAdminEnableUserResult> adminEnableUserWith({
    required AortemCognitoEnableUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminEnableUserConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminForgetDeviceResult> adminForgetDevice({
    required String userPoolId,
    required String username,
    required String deviceKey,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminForgetDeviceRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminForgetDeviceResult> adminForgetDeviceWith({
    required AortemCognitoForgetDeviceConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminForgetDeviceConsumer(
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
  /// @return Future resolving to [AortemCognitoAdminGetDeviceResult] containing device details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminGetDeviceResult> adminGetDevice({
    required String userPoolId,
    required String username,
    required String deviceKey,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminGetDeviceRequest(
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
  /// @return Future resolving to [AortemCognitoAdminGetDeviceResult] containing device details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminGetDeviceResult> adminGetDeviceWith({
    required AortemCognitoGetDeviceConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminGetDeviceConsumer(
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
  /// @return Future resolving to [AortemCognitoAdminGetUserResult] containing user details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminGetUserResult> adminGetUser({
    required String userPoolId,
    required String username,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminGetUserRequest(
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
  /// @return Future resolving to [AortemCognitoAdminGetUserResult] containing user details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  ///
  /// Example:
  /// ```dart
  /// await client.adminGetUserWith(
  ///    (b) => b
  ///      .userPoolId('us-east-1_abc123')
  ///      .username('user.to.query@example.com'),
  /// );
  /// ```
  Future<AortemCognitoAdminGetUserResult> adminGetUserWith({
    required AortemCognitoGetUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminGetUserConsumer(
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
  /// @return Future resolving to [AortemCognitoAdminInitiateAuthResult] with tokens or challenge details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminInitiateAuthResult> adminInitiateAuth({
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
    final req = AortemCognitoAdminInitiateAuthRequest(
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
  /// @return Future resolving to [AortemCognitoAdminInitiateAuthResult] with tokens or challenge details.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminInitiateAuthResult> adminInitiateAuthWith({
    required AortemCognitoAdminInitiateAuthConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminInitiateAuthConsumer(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminLinkProviderForUserResult> adminLinkProviderForUser({
    required String userPoolId,
    required AortemCognitoProviderUserLinkingIdentifier destinationUser,
    required AortemCognitoProviderUserLinkingIdentifier sourceUser,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminLinkProviderForUserRequest(
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
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminLinkProviderForUserResult>
  adminLinkProviderForUserWith({
    required AortemCognitoAdminLinkProviderForUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminLinkProviderForUserConsumer(
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
  /// @return Future resolving to [AortemCognitoAdminListDevicesResult] containing device list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminListDevicesResult> adminListDevices({
    required String userPoolId,
    required String username,
    int? limit,
    String? paginationToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminListDevicesRequest(
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
  /// @return Future resolving to [AortemCognitoAdminListDevicesResult] containing device list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminListDevicesResult> adminListDevicesWith({
    required AortemCognitoAdminListDevicesConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminListDevicesConsumer(
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
  /// @return Future resolving to [AortemCognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
  Future<AortemCognitoAdminListGroupsForUserResult> adminListGroupsForUser({
    required String userPoolId,
    required String username,
    int? limit,
    String? nextToken,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final req = AortemCognitoAdminListGroupsForUserRequest(
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
  /// @return Future resolving to [AortemCognitoAdminListGroupsForUserResult] containing group list and pagination token.
  /// @throws AortemCognitoValidationException for invalid parameters.
  /// @throws AortemCognitoServiceException for API failures.
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
  Future<AortemCognitoAdminListGroupsForUserResult> adminListGroupsForUserWith({
    required AortemCognitoAdminListGroupsForUserConsumerFn consumer,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) async {
    final c = AortemCognitoAdminListGroupsForUserConsumer(
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
  /// @return An instance of [AortemCognitoAdminListGroupsForUserPaginatorRequest].
  /// @throws AortemCognitoValidationException for invalid parameters.

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
  /// @return An instance of [AortemCognitoAdminListGroupsForUserPaginatorConsumer].
  /// @throws AortemCognitoValidationException for invalid parameters.
  AortemCognitoAdminListGroupsForUserPaginatorConsumer
  adminListGroupsForUserPaginator({
    required String userPoolId,
    required String username,
    int? limit,
    int maxRetries = 2,
    Duration requestTimeout = const Duration(seconds: 20),
  }) {
    return AortemCognitoAdminListGroupsForUserPaginatorConsumer(
      region: region,
      httpClient: httpClient,
      maxRetries: maxRetries,
      requestTimeout: requestTimeout,
    ); // Set initial values
  }
}
