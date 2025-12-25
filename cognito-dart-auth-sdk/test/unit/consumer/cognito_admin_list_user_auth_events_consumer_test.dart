import 'dart:convert';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_user_auth_events_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';

class _FakeHttp implements CognitoHttpClient {
  int calls = 0;

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    calls++;
    if (calls == 1) {
      return CognitoHttpResponse(
        statusCode: 200,
        headers: const {},
        bodyString: jsonEncode({
          'AuthEvents': [
            {'EventId': 'A1', 'EventType': 'SignIn'},
          ],
          'NextToken': 'NEXT',
        }),
      );
    }
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'AuthEvents': [
          {'EventId': 'A2', 'EventType': 'SignIn'},
        ],
      }),
    );
  }

  @override
  Future<CognitoHttpResponse> post({
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
  test('consumer runAll aggregates all events', () async {
    final http = _FakeHttp();
    final consumer = CognitoAdminListUserAuthEventsConsumer(
      region: 'us-west-2',
      httpClient: http,
    );

    final all = await consumer.runAll(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser')
        ..maxResults(2),
    );

    expect(all.map((e) => e['EventId']), ['A1', 'A2']);
  });

  test('consumer runPages yields pages', () async {
    final http = _FakeHttp();
    final consumer = CognitoAdminListUserAuthEventsConsumer(
      region: 'us-west-2',
      httpClient: http,
    );

    final ids = <String>[];
    await for (final page in consumer.runPages(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser'),
    )) {
      for (final ev in page.authEvents) {
        ids.add(ev['EventId'] as String);
      }
    }

    expect(ids, ['A1', 'A2']);
  });
}
