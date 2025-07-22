import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_create_user_consumer.dart';

class AdminCreateUserConsumerScreen extends StatefulWidget {
  const AdminCreateUserConsumerScreen({super.key});

  @override
  State<AdminCreateUserConsumerScreen> createState() =>
      _AdminCreateUserConsumerScreenState();
}

class _AdminCreateUserConsumerScreenState
    extends State<AdminCreateUserConsumerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _resultMessage = '';
  bool _isLoading = false;

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _resultMessage = '';
    });

    try {
      final consumer = AortemCognitoAdminCreateUserConsumer(
        userPoolId: 'your_user_pool_id',
        region: 'your-region',
      );

      await consumer.createUser((builder) {
        builder.setUsername(_usernameController.text.trim());
        builder.setEmail(_emailController.text.trim());

        if (_phoneController.text.trim().isNotEmpty) {
          builder.addAttribute('phone_number', _phoneController.text.trim());
        }

        // Add other custom attributes if needed
        // builder.addAttribute('custom:role', 'admin');
      });

      setState(() {
        _resultMessage = '✅ User created successfully!';
      });
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Create User (Consumer API)')),
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
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (optional)',
                ),
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
                  color: _resultMessage.startsWith('❌')
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
