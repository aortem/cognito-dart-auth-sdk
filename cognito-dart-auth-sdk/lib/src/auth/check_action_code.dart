import 'dart:convert';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

///checkaction class
class CheckActionCodeService {
  ///auth
  final cognitoAuth auth;

  ///checkaction service
  CheckActionCodeService({required this.auth});

  ///checkaction function
  Future<ActionCodeInfo> checkActionCode(String code) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:resetPassword',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'oobCode': code,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw cognitoAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);
      return ActionCodeInfo.fromJson(data);
    } catch (e) {
      throw cognitoAuthException(
        code: 'check-action-code-error',
        message: 'Failed to check action code: ${e.toString()}',
      );
    }
  }
}

///actioncodeinfo
class ActionCodeInfo {
  ///actioncode
  final String operation;

  ///data
  final Map<String, dynamic> data;

  ///actioncodeinfo
  ActionCodeInfo({required this.operation, required this.data});

  ///fromJSON
  factory ActionCodeInfo.fromJson(Map<String, dynamic> json) {
    return ActionCodeInfo(
      operation: json['requestType'],
      data: {
        'email': json['email'],
        'newEmail': json['newEmail'],
      }..removeWhere((key, value) => value == null),
    );
  }
}
