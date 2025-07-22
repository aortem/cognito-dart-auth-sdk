import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_delete_user_attributes_request.dart';

class DeleteUserAttributesScreen extends StatefulWidget {
  const DeleteUserAttributesScreen({super.key});

  @override
  State<DeleteUserAttributesScreen> createState() =>
      _DeleteUserAttributesScreenState();
}

class _DeleteUserAttributesScreenState
    extends State<DeleteUserAttributesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _attributesController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _deleteAttributes() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final attributes = _attributesController.text
        .split(',')
        .map((attr) => attr.trim())
        .where((attr) => attr.isNotEmpty)
        .toList();

    final adminDelete = AortemCognitoAdminDeleteUserAttributesRequest(
      userPoolId: 'us-west-2_12345', // Replace with your actual UserPoolId
      region: 'us-west-2',
    );

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      await adminDelete.deleteUserAttributes(
        username: username,
        attributeNames: attributes,
      );
      setState(() => _result = 'Attributes deleted successfully.');
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete User Attributes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _attributesController,
                decoration: const InputDecoration(
                  labelText: 'Attributes (comma separated)',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _deleteAttributes,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Delete Attributes'),
              ),
              const SizedBox(height: 20),
              Text(_result),
            ],
          ),
        ),
      ),
    );
  }
}
