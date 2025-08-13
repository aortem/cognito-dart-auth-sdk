import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_confirm_sign_up_consumer.dart';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  int status = 200;
  String body = '{}';

  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastPayload = payload;
    return AortemCognitoHttpResponse(
      statusCode: status,
      headers: const {},
      bodyString: body,
    );
  }

  @override
  Future<AortemCognitoHttpResponse> post({
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
  group('AdminConfirmSignUpConsumer (Ticket #5)', () {
    test('happy path sends minimal payload', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminConfirmSignUpConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser'),
      );

      expect(res, isNotNull);
      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p.containsKey('ClientMetadata'), isFalse);
    });

    test('adds clientMetadata when provided', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminConfirmSignUpConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('user1')
          ..meta('source', 'admin'),
      );

      final p = http.lastPayload!;
      expect(p['ClientMetadata'], {'source': 'admin'});
    });
  });
}
