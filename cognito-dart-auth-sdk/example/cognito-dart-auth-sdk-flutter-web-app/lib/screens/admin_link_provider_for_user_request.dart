import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_link_provider_for_user_request.dart';

class AdminLinkProviderScreen extends StatefulWidget {
  const AdminLinkProviderScreen({super.key});

  @override
  State<AdminLinkProviderScreen> createState() =>
      _AdminLinkProviderScreenState();
}

class _AdminLinkProviderScreenState extends State<AdminLinkProviderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _providerNameController = TextEditingController();
  final _providerUserIdController = TextEditingController();

  bool _isLoading = false;
  String? _message;

  final _adminLinkProvider = AortemCognitoAdminLinkProviderForUserRequest(
    userPoolId: 'your_user_pool_id',
    region: 'your_aws_region',
  );

  Future<void> _linkProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _adminLinkProvider.linkProviderForUser(
        username: _usernameController.text.trim(),
        providerName: _providerNameController.text.trim(),
        providerUserId: _providerUserIdController.text.trim(),
      );
      setState(() {
        _message = '✅ Successfully linked provider.';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Failed to link: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _providerNameController.dispose();
    _providerUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Link Provider for User')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Cognito Username',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Username is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _providerNameController,
                decoration: const InputDecoration(
                  labelText: 'Provider Name (e.g., Google)',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Provider name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _providerUserIdController,
                decoration: const InputDecoration(
                  labelText: 'Provider User ID',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Provider user ID is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _linkProvider,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Link Provider'),
              ),
              if (_message != null) ...[
                const SizedBox(height: 20),
                Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
