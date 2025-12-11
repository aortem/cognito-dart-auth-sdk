import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_create_user_request.dart';

class AdminCreateUserScreen extends StatefulWidget {
  const AdminCreateUserScreen({super.key});

  @override
  State<AdminCreateUserScreen> createState() => _AdminCreateUserScreenState();
}

class _AdminCreateUserScreenState extends State<AdminCreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _tempPasswordController = TextEditingController();

  String _resultMessage = '';
  bool _isLoading = false;

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _resultMessage = '';
    });

    try {
      final creator = AortemCognitoAdminCreateUserRequest(
        userPoolId: 'your_user_pool_id',
        region: 'your-region',
      );

      await creator.createUser(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        attributes: {
          // Add any extra attributes here
          'custom:temporaryPassword': _tempPasswordController.text.trim(),
          'phone_number': '+1234567890',
        },
      );

      setState(() {
        _resultMessage = 'User created successfully.';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _tempPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Create Cognito User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a username' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                controller: _tempPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Temporary Password',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a temporary password' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createUser,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create User'),
              ),
              const SizedBox(height: 24),
              Text(
                _resultMessage,
                style: TextStyle(
                  color: _resultMessage.startsWith('Error')
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
