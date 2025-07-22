import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_delete_user_request.dart';

class DeleteUserApp extends StatelessWidget {
  const DeleteUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DeleteUserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({super.key});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _result = '';
  bool _loading = false;

  final _deleter = AortemCognitoAdminDeleteUserRequest(
    userPoolId: 'your-user-pool-id', // Replace this
    region: 'your-region', // Replace this
  );

  Future<void> _handleDelete() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() => _result = 'Username is required.');
      return;
    }

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      await _deleter.deleteUser(username: username);
      setState(() => _result = '✅ User "$username" deleted successfully.');
    } catch (e) {
      setState(() => _result = '❌ Error: ${e.toString()}');
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
      appBar: AppBar(title: const Text('Delete Cognito User')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Username to Delete:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _handleDelete,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Delete User'),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(
                color: _result.startsWith('✅') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
