import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_confirm_signup_request.dart';

class ConfirmSignUpRequestScreen extends StatefulWidget {
  const ConfirmSignUpRequestScreen({super.key});

  @override
  State<ConfirmSignUpRequestScreen> createState() =>
      _ConfirmSignUpRequestScreenState();
}

class _ConfirmSignUpRequestScreenState
    extends State<ConfirmSignUpRequestScreen> {
  final _usernameController = TextEditingController();
  final _codeController = TextEditingController();
  String _message = '';
  bool _loading = false;

  final _confirmSignUpRequest = AortemCognitoConfirmSignUpRequest(
    region: 'us-west-2', // replace with your region
    clientId: 'your-client-id', // replace with your Cognito app client ID
  );

  Future<void> _confirm() async {
    setState(() {
      _loading = true;
      _message = '';
    });

    try {
      await _confirmSignUpRequest.confirmSignUp(
        username: _usernameController.text.trim(),
        confirmationCode: _codeController.text.trim(),
      );
      setState(() {
        _message = 'User confirmed successfully.';
      });
    } catch (e) {
      setState(() {
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Confirmation Code'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _confirm,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Confirm'),
            ),
            const SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith('Error') ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
