import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/cognito_sign_up_consumer.dart';

class SignUpConsumerScreen extends StatefulWidget {
  const SignUpConsumerScreen({super.key});

  @override
  State<SignUpConsumerScreen> createState() => _SignUpConsumerScreenState();
}

class _SignUpConsumerScreenState extends State<SignUpConsumerScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String message = '';
  bool loading = false;

  final consumer = AortemCognitoSignUpConsumer(
    userPoolId: 'us-west-2_12345',
    clientId: 'your-client-id',
    region: 'us-west-2',
  );

  Future<void> handleSignUp() async {
    setState(() {
      loading = true;
      message = '';
    });

    try {
      await consumer.signUp((userDetails) {
        userDetails['Username'] = usernameController.text.trim();
        userDetails['Password'] = passwordController.text.trim();
        userDetails['email'] = emailController.text.trim();
        userDetails['phone_number'] = phoneController.text.trim();
      });

      setState(() => message = '✅ User registered successfully');
    } catch (e) {
      setState(() => message = '❌ Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up (Consumer)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : handleSignUp,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: message.startsWith('✅') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
