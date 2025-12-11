import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_add_custom_attributes_request.dart';
import 'package:cognito_dart_auth_sdk/models/add_custom_attributes_request_model.dart';

class AddCustomAttributesScreen extends StatefulWidget {
  const AddCustomAttributesScreen({super.key});

  @override
  State<AddCustomAttributesScreen> createState() =>
      _AddCustomAttributesScreenState();
}

class _AddCustomAttributesScreenState extends State<AddCustomAttributesScreen> {
  final TextEditingController _userPoolIdController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final List<Map<String, dynamic>> _attributes = [];

  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _type;
  bool _mutable = true;
  String _message = '';

  void _addAttribute() {
    if ((_name?.isNotEmpty ?? false) && (_type?.isNotEmpty ?? false)) {
      setState(() {
        _attributes.add({
          'Name': _name!,
          'AttributeDataType': _type!,
          'Mutable': _mutable,
        });
        _name = null;
        _type = null;
        _mutable = true;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _message = '';
    });

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final attributes = _attributes.map((attr) {
          return AortemCognitoCustomAttribute(
            name: attr['Name'],
            attributeDataType: attr['AttributeDataType'],
            mutable: attr['Mutable'],
          );
        }).toList();
        final request = AortemCognitoAddCustomAttributesRequest(
          userPoolId: _userPoolIdController.text.trim(),
          region: _regionController.text.trim(),
          attributes: attributes,
        );

        final response = await request.send();

        setState(() {
          _message = '✅ Successfully added custom attributes: ${response.body}';
          _attributes.clear();
        });
      } catch (e) {
        setState(() {
          _message = '❌ Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Attributes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userPoolIdController,
                decoration: const InputDecoration(labelText: 'User Pool ID'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'AWS Region'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              const Text('Add Attribute:'),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (val) => _name = val,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'AttributeDataType',
                ),
                onChanged: (val) => _type = val,
              ),
              SwitchListTile(
                value: _mutable,
                onChanged: (val) => setState(() => _mutable = val),
                title: const Text('Mutable'),
              ),
              ElevatedButton(
                onPressed: _addAttribute,
                child: const Text('Add to List'),
              ),
              const SizedBox(height: 16),
              if (_attributes.isNotEmpty) ...[
                const Text('Attributes to Add:'),
                for (var attr in _attributes)
                  Text(attr.toString(), style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit to Cognito'),
              ),
              const SizedBox(height: 16),
              Text(_message, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
