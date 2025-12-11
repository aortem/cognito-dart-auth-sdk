import 'package:cognito/screens/add_custom_attributes_consumer_screen.dart';
import 'package:cognito/screens/add_custom_attributes_request_screen.dart';
import 'package:cognito/screens/admin_add_user_to_group_consumer_screen.dart';
import 'package:cognito/screens/admin_add_user_to_group_screen.dart';
import 'package:cognito/screens/admin_confirm_request_screen.dart';
import 'package:cognito/screens/admin_confirm_sign_up_screen.dart';
import 'package:cognito/screens/admin_create_user_consumer_screen.dart';
import 'package:cognito/screens/admin_create_user_screen.dart';
import 'package:cognito/screens/admin_delete_user_attributes_request.dart';
import 'package:cognito/screens/admin_delete_user_consumer_screen.dart';
import 'package:cognito/screens/admin_delete_user_request.dart';
import 'package:cognito/screens/admin_link_provider_for_user_request.dart';
import 'package:cognito/screens/confirm_signup_consumer_screen.dart';
import 'package:cognito/screens/confirm_signup_request_screen.dart';
import 'package:cognito/screens/signup_consumer_screen.dart';
import 'package:cognito/screens/signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CognitoSampleApp());
}

class CognitoSampleApp extends StatelessWidget {
  const CognitoSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cognito Dart Auth Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CognitoHomePage(),
        '/signup': (context) => const SignUpScreen(),
        '/signup-consumer': (context) => const SignUpConsumerScreen(),
        '/admin-confirm': (context) => const AdminConfirmSignUpScreen(),
        '/admin-confirm-request': (context) =>
            const AdminConfirmRequestScreen(),
        '/confirm-signup': (context) => const ConfirmSignUpRequestScreen(),
        '/confirm-consumer': (context) => const ConfirmSignUpConsumerScreen(),
        '/admin-link-provider': (context) => const AdminLinkProviderScreen(),
        '/add-custom-attributes': (context) =>
            const AddCustomAttributesScreen(),
        '/add-custom-attributes-consumer': (context) =>
            const AddCustomAttributesConsumerScreen(),
        '/admin-add-user-to-group': (context) =>
            const AdminAddUserToGroupScreen(),
        '/admin-add-user-to-group-consumer': (context) =>
            const AdminAddUserToGroupConsumerScreen(),
        '/admin-create-user-request': (context) =>
            const AdminCreateUserScreen(),
        '/admin-create-user-consumer': (context) =>
            const AdminCreateUserConsumerScreen(),
        '/admin-delete-user': (context) => const DeleteUserScreen(),
        '/admin-delete-user-consumer': (context) =>
            const DeleteUserConsumerScreen(),
        '/admin-delete-user-attributes': (context) =>
            const DeleteUserAttributesScreen(),
      },
    );
  }
}

class CognitoHomePage extends StatelessWidget {
  const CognitoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cognito Dart Auth Web Sample")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SDK Features:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FeatureButton(
                title: "AortemCognitoSignUpRequest", // #75
                description: "Sign up a new user using API request.",
                routeName: '/signup',
              ),
              FeatureButton(
                title: "AortemCognitoSignUpConsumer", // #75
                description: "Sign up a new user as a consumer.",
                routeName: '/signup-consumer',
              ),
              FeatureButton(
                title: "CognitoAdminConfirmSignUpConsumer", // #76
                description: "Confirm user sign-up using admin credentials.",
                routeName: '/admin-confirm',
              ),
              FeatureButton(
                title: "AortemCognitoAdminConfirmSignUpRequest",
                description: "Confirm user via admin API request call.",
                routeName: '/admin-confirm-request',
              ),
              FeatureButton(
                title: "AortemCognitoConfirmSignUpRequest",
                description: "Confirm user sign-up using API request.",
                routeName: '/confirm-signup',
              ),
              FeatureButton(
                title: "AortemCognitoConfirmSignUpConsumer",
                description: "Confirm user sign-up as a consumer.",
                routeName: '/confirm-consumer',
              ),
              FeatureButton(
                title: "AortemCognitoAdminLinkProviderForUserRequest",
                description:
                    "Link a provider to a user using admin API request.",
                routeName: '/admin-link-provider',
              ),
              FeatureButton(
                title: "AortemCognitoAddCustomAttributesRequest",
                description:
                    "Add custom attributes to a user pool using API request.",
                routeName: '/add-custom-attributes',
              ),
              FeatureButton(
                title: "AortemCognitoAddCustomAttributesConsumer",
                description:
                    "Add custom attributes to a user pool as a consumer.",
                routeName: '/add-custom-attributes-consumer',
              ),
              FeatureButton(
                title: "AortemCognitoAdminAddUserToGroupRequest",
                description:
                    "Add a user to a Cognito group using admin API request.",
                routeName: '/admin-add-user-to-group',
              ),
              FeatureButton(
                title: "AortemCognitoAdminAddUserToGroupConsumer",
                description: "Add a user to a Cognito group as a consumer.",
                routeName: '/admin-add-user-to-group-consumer',
              ),
              FeatureButton(
                title: "AortemCognitoAdminCreateUserRequest",
                description:
                    "Create a user in Cognito using admin API request.",
                routeName: '/admin-create-user-request',
              ),
              FeatureButton(
                title: "AortemCognitoAdminCreateUserConsumer",
                description: "Create a user in Cognito as a consumer.",
                routeName: '/admin-create-user-consumer',
              ),
              FeatureButton(
                title: "AortemCognitoAdminDeleteUserRequest",
                description:
                    "Delete a user in Cognito using admin API request.",
                routeName: '/admin-delete-user',
              ),
              FeatureButton(
                title: "AortemCognitoAdminDeleteUserConsumer",
                description: "Delete a user in Cognito as a consumer.",
                routeName: '/admin-delete-user-consumer',
              ),
              FeatureButton(
                title: "AortemCognitoAdminDeleteUserAttributesRequest",
                description:
                    "Delete user attributes in Cognito using admin API request.",
                routeName: '/admin-delete-user-attributes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String title;
  final String description;
  final String routeName;

  const FeatureButton({
    super.key,
    required this.title,
    required this.description,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, routeName),
      ),
    );
  }
}
