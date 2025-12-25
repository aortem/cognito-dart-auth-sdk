// test/   cognito_admin_add_user_to_group_consumer_test.dart
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_add_user_to_group_consumer.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  int status = 200;

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastPayload = payload;
    return CognitoHttpResponse(
      statusCode: status,
      headers: const {},
      bodyString: '{}',
    );
  }

  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) => send(
    service: 'cognito-idp',
    target: xAmzTarget,
    region: region,
    payload: payload,
    timeout: timeout ?? const Duration(seconds: 20),
    headers: additionalHeaders,
  );
}

void main() {
  group('AdminAddUserToGroupConsumer', () {
    test('happy path builds and sends payload', () async {
      final http = _FakeHttp();
      final consumer = CognitoAdminAddUserToGroupConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final result = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser')
          ..groupName('testgroup'),
      );

      expect(result, isNotNull);
      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['GroupName'], 'testgroup');
    });

    test('missing fields throw validation before HTTP', () async {
      final http = _FakeHttp();
      final consumer = CognitoAdminAddUserToGroupConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('') // missing
            ..username('user')
            ..groupName('grp'),
        ),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
