import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_confirm_signup_consumer.dart';

class ConfirmSignUpConsumerScreen extends StatefulWidget {
  const ConfirmSignUpConsumerScreen({super.key});

  @override
  State<ConfirmSignUpConsumerScreen> createState() =>
      _ConfirmSignUpConsumerScreenState();
}

class _ConfirmSignUpConsumerScreenState
    extends State<ConfirmSignUpConsumerScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _status = '';
  bool _loading = false;

  final _consumer = AortemCognitoConfirmSignUpConsumer(
    region: 'us-west-2', // replace with your AWS region
    clientId: 'your-client-id', // replace with your app client ID
  );

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _status = '';
    });

    try {
      await _consumer.confirmSignUp((userDetails) {
        userDetails['Username'] = _usernameController.text.trim();
        userDetails['ConfirmationCode'] = _codeController.text.trim();
      });

      setState(() {
        _status = '✅ User confirmed successfully.';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
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
      appBar: AppBar(title: const Text('Confirm Sign-Up (Consumer)')),
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
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Confirm User'),
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
