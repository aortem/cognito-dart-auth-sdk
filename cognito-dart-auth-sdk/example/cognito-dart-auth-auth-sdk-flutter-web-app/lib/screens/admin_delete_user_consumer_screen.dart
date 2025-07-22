import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_delete_user_consumer.dart';

class DeleteUserConsumerScreen extends StatefulWidget {
  const DeleteUserConsumerScreen({super.key});

  @override
  State<DeleteUserConsumerScreen> createState() =>
      _DeleteUserConsumerScreenState();
}

class _DeleteUserConsumerScreenState extends State<DeleteUserConsumerScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _status = '';
  bool _loading = false;

  final _consumer = AortemCognitoAdminDeleteUserConsumer(
    userPoolId: 'your-user-pool-id', // Replace with your actual value
    region: 'your-region', // Replace with your actual AWS region
  );

  Future<void> _deleteUser() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() => _status = '⚠️ Please enter a username.');
      return;
    }

    setState(() {
      _loading = true;
      _status = '';
    });

    try {
      await _consumer.deleteUser((userDetails) {
        userDetails['Username'] = username;
      });
      setState(() => _status = '✅ User "$username" deleted successfully.');
    } catch (e) {
      setState(() => _status = '❌ Error: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
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
      appBar: AppBar(title: const Text('Delete User via Consumer')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Username to delete:'),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Cognito Username',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _deleteUser,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Delete User'),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                color: _status.contains('✅') ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
