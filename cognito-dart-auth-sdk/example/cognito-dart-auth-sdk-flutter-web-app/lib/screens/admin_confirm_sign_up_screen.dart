import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_confirm_sign_up_consumer.dart';
import 'package:flutter/material.dart';

class AdminConfirmSignUpScreen extends StatefulWidget {
  const AdminConfirmSignUpScreen({Key? key}) : super(key: key);

  @override
  State<AdminConfirmSignUpScreen> createState() =>
      _AdminConfirmSignUpScreenState();
}

class _AdminConfirmSignUpScreenState extends State<AdminConfirmSignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;

  final _consumer = AortemCognitoAdminConfirmSignUpConsumer(
    userPoolId: 'us-west-2_12345', // <-- Replace with actual UserPoolId
    region: 'us-west-2', // <-- Replace with actual region
  );

  Future<void> _confirmUser() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      await _consumer.confirmSignUp((userDetails) {
        userDetails['Username'] = _usernameController.text.trim();
      });
      setState(() {
        _statusMessage = '✅ User confirmed successfully.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Confirm Sign-Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Username to Confirm',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _confirmUser,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm User'),
            ),
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(
                _statusMessage,
                style: TextStyle(
                  color: _statusMessage.startsWith('✅')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
