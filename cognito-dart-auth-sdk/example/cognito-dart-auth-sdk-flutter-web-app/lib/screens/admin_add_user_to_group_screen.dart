import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_add_user_to_group_request.dart';

class AdminAddUserToGroupScreen extends StatefulWidget {
  const AdminAddUserToGroupScreen({super.key});

  @override
  State<AdminAddUserToGroupScreen> createState() =>
      _AdminAddUserToGroupScreenState();
}

class _AdminAddUserToGroupScreenState extends State<AdminAddUserToGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _userPoolIdController = TextEditingController();
  final _regionController = TextEditingController();

  String? _result;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final request = AortemCognitoAdminAddUserToGroupRequest(
      username: _usernameController.text.trim(),
      groupName: _groupNameController.text.trim(),
      userPoolId: _userPoolIdController.text.trim(),
      region: _regionController.text.trim(),
    );

    try {
      final response = await request.send(); // or .submit() based on SDK
      setState(() {
        _result = '✅ User added to group successfully: ${response.toString()}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
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
      appBar: AppBar(title: const Text('Add User to Cognito Group')),
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
              if (_result != null) Text(_result!),
            ],
          ),
        ),
      ),
    );
  }
}
