import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_confirm_sign_up_request.dart';

class AdminConfirmRequestScreen extends StatefulWidget {
  const AdminConfirmRequestScreen({super.key});

  @override
  State<AdminConfirmRequestScreen> createState() =>
      _AdminConfirmRequestScreenState();
}

class _AdminConfirmRequestScreenState extends State<AdminConfirmRequestScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;

  final _adminRequest = AortemCognitoAdminConfirmSignUpRequest(
    userPoolId: 'us-west-2_12345', // <-- replace with actual
    region: 'us-west-2',
  );

  Future<void> _confirmUser() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      await _adminRequest.confirmUser(
        username: _usernameController.text.trim(),
      );
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
      appBar: AppBar(title: const Text('Admin Confirm via Request')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Enter Username to Confirm (Request)',
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
