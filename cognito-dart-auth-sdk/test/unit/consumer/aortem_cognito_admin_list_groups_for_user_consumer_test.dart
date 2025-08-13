import 'dart:convert';
import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_list_groups_for_user_consumer.dart';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  Map<String, String> headers = const {};
  String bodyString = jsonEncode({
    'Groups': [
      {'GroupName': 'G1'},
    ],
  });

  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastTarget = target;
    lastRegion = region;
    lastHeaders = headers;
    lastPayload = payload;

    return AortemCognitoHttpResponse(
      statusCode: statusCode,
      headers: this.headers,
      bodyString: bodyString,
    );
  }

  @override
  Future<AortemCognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) {
    return send(
      service: 'cognito-idp',
      target: xAmzTarget,
      region: region,
      payload: payload,
      timeout: timeout ?? const Duration(seconds: 20),
      headers: additionalHeaders,
    );
  }
}

void main() {
  group('AdminListGroupsForUserConsumer (Ticket #32)', () {
    test('happy path: builds and sends payload', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminListGroupsForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final out = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser')
          ..limit(2),
      );

      expect(out.groups, isA<List>());
      expect(out.groups.first['GroupName'], 'G1');

      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminListGroupsForUser',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['Limit'], 2);
    });

    test('missing requireds throw before HTTP', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminListGroupsForUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // missing pool id
      expect(
        () => consumer.run((b) => b..username('u')),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // missing username
      expect(
        () => consumer.run((b) => b..userPoolId('us-west-2_EXAMPLE')),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
