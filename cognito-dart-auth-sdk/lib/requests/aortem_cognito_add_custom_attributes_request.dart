// add_custom_attributes_request.dart
import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;



/// Class to send a request to Cognito to add custom attributes.
class AortemCognitoAddCustomAttributesRequest {
  final String userPoolId;
  final String region;
  final List<AortemCognitoCustomAttribute> attributes;
  final Future<http.Request> Function(http.Request request)? signer;

  AortemCognitoAddCustomAttributesRequest({
    required this.userPoolId,
    required this.region,
    required this.attributes,
    this.signer,
  });

  /// Validates all attributes before sending request.
  void _validateAttributes() {
    if (attributes.isEmpty) {
      throw AortemCognitoAttributeValidationException('No attributes provided.');
    }
    for (final attr in attributes) {
      attr.validate();
    }
  }

  /// Builds the HTTP request to call AddCustomAttributes.
  Future<http.Response> send() async {
    _validateAttributes();

    final uri = Uri.https(
      'cognito-idp.$region.amazonaws.com',
      '/',
    );

    final payload = {
      'UserPoolId': userPoolId,
      'CustomAttributes': attributes.map((a) => a.toJson()).toList(),
    };

    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'AWSCognitoIdentityProviderService.AddCustomAttributes',
      })
      ..body = jsonEncode(payload);

    // Apply SigV4 signer if provided
    final signedRequest = signer != null ? await signer!(request) : request;

    final client = http.Client();
    try {
      final streamedResponse = await client.send(signedRequest);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw AortemCognitoServiceException(
          'Failed to add attributes: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw AortemCognitoServiceException(
        'Request to Cognito failed: ${e.toString()}',
      );
    } finally {
      client.close();
    }
  }
}
