import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/consumers/add_custom_attributes_consumer.dart';
import 'package:cognito_dart_auth_sdk/models/add_custom_attributes_request_model.dart';

class AddCustomAttributesConsumerScreen extends StatefulWidget {
  const AddCustomAttributesConsumerScreen({super.key});

  @override
  State<AddCustomAttributesConsumerScreen> createState() =>
      _AddCustomAttributesConsumerScreenState();
}

class _AddCustomAttributesConsumerScreenState
    extends State<AddCustomAttributesConsumerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userPoolIdController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  String? _name;
  String? _type;
  bool _mutable = true;
  String _message = '';
  final List<AortemCognitoCustomAttribute> _attributes = [];

  void _addAttribute() {
    if ((_name?.isNotEmpty ?? false) && (_type?.isNotEmpty ?? false)) {
      setState(() {
        _attributes.add(
          AortemCognitoCustomAttribute(
            name: _name!,
            attributeDataType: _type!,
            mutable: _mutable,
          ),
        );
        _name = null;
        _type = null;
        _mutable = true;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _message = '');

    final consumer = AortemCognitoAddCustomAttributesConsumer(
      userPoolId: _userPoolIdController.text.trim(),
      region: _regionController.text.trim(),
    );

    try {
      await consumer.consume((builder) async {
        builder.addAll(_attributes);
      });

      await consumer.submit();

      setState(() {
        _message = '✅ Attributes added successfully.';
        _attributes.clear();
      });
    } catch (e) {
      setState(() {
        _message = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Custom Attributes (Consumer)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const Divider(height: 32),
              const Text('New Attribute:', style: TextStyle(fontSize: 16)),
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
                title: const Text("Mutable"),
              ),
              ElevatedButton(
                onPressed: _addAttribute,
                child: const Text("Add Attribute"),
              ),
              const SizedBox(height: 20),
              if (_attributes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Attributes to Add:"),
                    for (final attr in _attributes)
                      Text(
                        attr.toJson().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit to Cognito"),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(
                  color: _message.startsWith('✅') ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
