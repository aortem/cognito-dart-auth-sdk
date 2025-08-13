import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_sign_up_request.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _status = '';
  bool _loading = false;

  final _signupRequest = AortemCognitoSignUpRequest(
    userPoolId: 'us-west-2_12345', // ← replace with real pool ID
    clientId: 'your-client-id', // ← replace with real client ID
    region: 'us-west-2', // ← match region
  );

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _status = '';
    });

    try {
      await _signupRequest.signUp(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        userAttributes: {
          'email': _emailController.text.trim(),
          'phone_number': _phoneController.text.trim(),
        },
      );
      setState(() {
        _status = '✅ User registered successfully.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Sign-Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                color: _status.startsWith('✅') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
