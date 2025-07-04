// add_custom_attributes_consumer.dart
import 'aortem-cognito-add-custom-attributes-request.dart';

/// Exception thrown when the consumer fails to define valid attributes.
class AortemCognitoConsumerException implements Exception {
  final String message;
  AortemCognitoConsumerException(this.message);
  @override
  String toString() => 'ConsumerException: $message';
}

/// A functional consumer-style class for adding custom attributes to Cognito.
class AortemCognitoAddCustomAttributesConsumer {
  final String userPoolId;
  final String region;
  final Future<http.Request> Function(http.Request request)? signer;

  final List<AortemCognitoCustomAttribute> _attributes = [];

  AortemCognitoAddCustomAttributesConsumer({
    required this.userPoolId,
    required this.region,
    this.signer,
  });

  /// Applies a developer-supplied function to build the attributes list.
  Future<void> consume(
    FutureOr<void> Function(List<AortemCognitoCustomAttribute> builder)
    attributeBuilder,
  ) async {
    try {
      await attributeBuilder(_attributes);
    } catch (e) {
      throw AortemCognitoConsumerException(
        'Failed to build attributes via consumer: ${e.toString()}',
      );
    }

    if (_attributes.isEmpty) {
      throw AortemCognitoConsumerException(
        'No attributes were provided by the consumer.',
      );
    }
  }

  /// Sends the final request to the Cognito API after consumer population.
  Future<void> submit() async {
    final request = AortemCognitoAddCustomAttributesRequest(
      userPoolId: userPoolId,
      region: region,
      attributes: _attributes,
      signer: signer,
    );

    final response = await request.send();
    print('AddCustomAttributes API response: ${response.body}');
  }
}
