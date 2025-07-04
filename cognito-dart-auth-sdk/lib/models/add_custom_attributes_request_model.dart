/// Model representing a custom attribute to be added.
class AortemCognitoCustomAttribute {
  final String name;
  final String attributeDataType;
  final bool? developerOnlyAttribute;
  final bool? mutable;

  AortemCognitoCustomAttribute({
    required this.name,
    required this.attributeDataType,
    this.developerOnlyAttribute,
    this.mutable,
  });

  /// Validates attribute name and required fields.
  void validate() {
    if (name.isEmpty || attributeDataType.isEmpty) {
      throw AortemCognitoAttributeValidationException(
        'Name and AttributeDataType are required fields.',
      );
    }
    final nameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!nameRegex.hasMatch(name)) {
      throw AortemCognitoAttributeValidationException(
        'Invalid attribute name: "$name". Only alphanumeric characters and underscores are allowed.',
      );
    }
  }

  /// Serializes the attribute for the AWS Cognito API.
  Map<String, dynamic> toJson() {
    final json = {'Name': name, 'AttributeDataType': attributeDataType};
    if (developerOnlyAttribute != null) {
      json['DeveloperOnlyAttribute'] = developerOnlyAttribute;
    }
    if (mutable != null) {
      json['Mutable'] = mutable;
    }
    return json;
  }
}
