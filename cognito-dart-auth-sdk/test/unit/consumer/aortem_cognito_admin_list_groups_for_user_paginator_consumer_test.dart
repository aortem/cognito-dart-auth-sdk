import 'dart:convert';
import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_list_groups_for_user_paginator_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements CognitoHttpClient {
  int callCount = 0;

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    callCount += 1;
    if (callCount == 1) {
      return CognitoHttpResponse(
        statusCode: 200,
        headers: const {},
        bodyString: jsonEncode({
          'Groups': [
            {'GroupName': 'Admins'},
          ],
          'NextToken': 'NEXT',
        }),
      );
    }
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'Groups': [
          {'GroupName': 'Editors'},
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
  test('Paginator consumer runAll aggregates all pages', () async {
    final http = _FakeHttp();
    final consumer = CognitoAdminListGroupsForUserPaginatorConsumer(
      region: 'us-west-2',
      httpClient: http,
    );

    final all = await consumer.runAll(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser')
        ..limit(1),
    );

    expect(all, hasLength(2));
    expect(all.first['GroupName'], 'Admins');
    expect(all.last['GroupName'], 'Editors');
  });

  test('Paginator consumer runPages yields pages', () async {
    final http = _FakeHttp();
    final consumer = CognitoAdminListGroupsForUserPaginatorConsumer(
      region: 'us-west-2',
      httpClient: http,
    );

    final names = <String>[];
    await for (final page in consumer.runPages(
      (b) => b
        ..userPoolId('us-west-2_EXAMPLE')
        ..username('testuser'),
    )) {
      for (final g in page.groups) {
        names.add(g['GroupName'] as String);
      }
    }
    expect(names, ['Admins', 'Editors']);
  });
}
