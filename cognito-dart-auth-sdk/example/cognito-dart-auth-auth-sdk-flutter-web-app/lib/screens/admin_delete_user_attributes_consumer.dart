import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_delete_user_attributes_consumer.dart';

class DeleteUserAttributesScreen extends StatefulWidget {
  const DeleteUserAttributesScreen({super.key});

  @override
  State<DeleteUserAttributesScreen> createState() =>
      _DeleteUserAttributesScreenState();
}

class _DeleteUserAttributesScreenState
    extends State<DeleteUserAttributesScreen> {
  final _usernameController = TextEditingController();
  final _attributeNamesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _statusMessage = '';
  bool _isLoading = false;

  Future<void> _deleteAttributes() async {
    if (!_formKey.currentState!.validate()) return;

    final consumer = AortemCognitoAdminDeleteUserAttributesConsumer(
      userPoolId: 'your_user_pool_id',
      region: 'your_region',
    );

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      await consumer.deleteUserAttributes((userDetails) {
        userDetails['Username'] = _usernameController.text.trim();
        userDetails['UserAttributeNames'] = _attributeNamesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList();
      });

      setState(() {
        _statusMessage = 'Attributes deleted successfully.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
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
    _attributeNamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete User Attributes')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Cognito username',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Username is required'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Attribute Names (comma-separated)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _attributeNamesController,
                decoration: const InputDecoration(
                  hintText: 'e.g. email, phone_number',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'At least one attribute name is required'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _deleteAttributes,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Delete Attributes'),
              ),
              const SizedBox(height: 16),
              if (_statusMessage.isNotEmpty)
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('Error')
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
