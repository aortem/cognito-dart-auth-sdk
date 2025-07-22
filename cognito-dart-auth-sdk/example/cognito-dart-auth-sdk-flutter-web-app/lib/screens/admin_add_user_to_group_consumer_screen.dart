import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/admin_add_user_to_group_consumer.dart';

class AdminAddUserToGroupConsumerScreen extends StatefulWidget {
  const AdminAddUserToGroupConsumerScreen({super.key});

  @override
  State<AdminAddUserToGroupConsumerScreen> createState() =>
      _AdminAddUserToGroupConsumerScreenState();
}

class _AdminAddUserToGroupConsumerScreenState
    extends State<AdminAddUserToGroupConsumerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _userPoolIdController = TextEditingController();
  final _regionController = TextEditingController();

  String? _statusMessage;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final consumer = AortemCognitoAdminAddUserToGroupConsumer(
      userPoolId: _userPoolIdController.text.trim(),
      region: _regionController.text.trim(),
    );

    try {
      await consumer.consume((builder) {
        builder.username = _usernameController.text.trim();
        builder.groupName = _groupNameController.text.trim();
      });

      setState(() {
        _statusMessage = '✅ User successfully added to group.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _groupNameController.dispose();
    _userPoolIdController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User to Cognito Group (Consumer)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _userPoolIdController,
                decoration: const InputDecoration(labelText: 'User Pool ID'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'Region'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: Text(_isLoading ? 'Processing...' : 'Submit'),
              ),
              const SizedBox(height: 20),
              if (_statusMessage != null)
                Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _statusMessage!.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
