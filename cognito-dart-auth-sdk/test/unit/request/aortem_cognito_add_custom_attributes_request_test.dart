import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_add_custom_attributes_consumer.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemCognitoAttributeBuilder', () {
    test('string() adds custom: prefix and constraints', () {
      final builder = AortemCognitoAttributeBuilder()
        ..string(name: 'deliverables', minLength: '1', maxLength: '255');

      final attrs = builder.build();
      expect(attrs.single.name, 'custom:deliverables');
      expect(attrs.single.stringAttributeConstraints?.minLength, '1');
      expect(attrs.single.stringAttributeConstraints?.maxLength, '255');
    });

    test('developerOnly true gets dev: prefix', () {
      final builder = AortemCognitoAttributeBuilder()
        ..boolean(name: 'flag', developerOnly: true);

      final attrs = builder.build();
      expect(attrs.single.name, 'dev:flag');
      expect(attrs.single.developerOnlyAttribute, true);
    });

    test('throws if attribute name empty', () {
      final builder = AortemCognitoAttributeBuilder();
      expect(
        () => builder.string(name: ''),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
