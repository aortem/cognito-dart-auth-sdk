import 'dart:convert';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_list_groups_for_user_paginator_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  int callCount = 0;

  @override
  Future<AortemCognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    callCount += 1;
    // Page 1 -> NextToken
    if (callCount == 1) {
      return AortemCognitoHttpResponse(
        statusCode: 200,
        headers: const {},
        bodyString: jsonEncode({
          'Groups': [
            {'GroupName': 'G1'}
          ],
          'NextToken': 'NEXT',
        }),
      );
    }
    // Page 2 -> no NextToken
    return AortemCognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'Groups': [
          {'GroupName': 'G2'}
        ],
      }),
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
  test('Paginator request fetchAll returns all groups across pages', () async {
    final http = _FakeHttp();
    final pager = AortemCognitoAdminListGroupsForUserPaginatorRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
      limit: 1,
    );

    final all = await pager.fetchAll();
    expect(all, hasLength(2));
    expect(all[0]['GroupName'], 'G1');
    expect(all[1]['GroupName'], 'G2');
    expect(http.callCount, 2);
  });

  test('Paginator request paginate() yields two pages', () async {
    final http = _FakeHttp();
    final pager = AortemCognitoAdminListGroupsForUserPaginatorRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
      limit: 1,
    );

    final pages = <AortemCognitoAdminListGroupsForUserPage>[];
    await for (final p in pager.paginate()) {
      pages.add(p);
    }
    expect(pages, hasLength(2));
    expect(pages[0].groups.first['GroupName'], 'G1');
    expect(pages[1].groups.first['GroupName'], 'G2');
  });
}
