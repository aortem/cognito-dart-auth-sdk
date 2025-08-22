import 'dart:convert';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_user_auth_events_paginator_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttpSinglePage implements CognitoHttpClient {
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
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'AuthEvents': [
          {'EventId': 'ok-1'},
          {'EventId': 'ok-2'},
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
  test('Consumer.fetchPage returns a single page via builder', () async {
    final consumer = CognitoAdminListUserAuthEventsPaginatorConsumer(
      region: 'us-west-2',
      httpClient: _FakeHttpSinglePage(),
    );

    final page = await consumer.fetchPage(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser'),
      pageSize: 25,
    );

    expect(page.authEvents.length, 2);
    expect(page.nextToken, isNull);
    expect(page.authEvents.first['EventId'], 'ok-1');
  });
}
