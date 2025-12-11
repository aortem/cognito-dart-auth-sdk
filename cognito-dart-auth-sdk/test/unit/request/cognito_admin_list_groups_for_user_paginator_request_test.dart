import 'dart:convert';

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_groups_for_user_paginator_request.dart';
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
    // Page 1 -> NextToken
    if (callCount == 1) {
      return CognitoHttpResponse(
        statusCode: 200,
        headers: const {},
        bodyString: jsonEncode({
          'Groups': [
            {'GroupName': 'G1'},
          ],
          'NextToken': 'NEXT',
        }),
      );
    }
    // Page 2 -> no NextToken
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'Groups': [
          {'GroupName': 'G2'},
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
  test('Paginator request fetchAll returns all groups across pages', () async {
    final http = _FakeHttp();
    final pager = CognitoAdminListGroupsForUserPaginatorRequest(
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
    final pager = CognitoAdminListGroupsForUserPaginatorRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
      limit: 1,
    );

    final pages = <CognitoAdminListGroupsForUserPage>[];
    await for (final p in pager.paginate()) {
      pages.add(p);
    }
    expect(pages, hasLength(2));
    expect(pages[0].groups.first['GroupName'], 'G1');
    expect(pages[1].groups.first['GroupName'], 'G2');
  });
}
