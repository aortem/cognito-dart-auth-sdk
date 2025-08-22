import 'dart:convert';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_user_auth_events_paginator_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

/// Minimal fake that returns 2 pages, then finishes.
class _FakeHttpTwoPages implements CognitoHttpClient {
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
            {'EventId': 'e1'},
            {'EventId': 'e2'},
          ],
          'NextToken': 'NT1',
        }),
      );
    }
    // second (and last) page
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'AuthEvents': [
          {'EventId': 'e3'},
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
  test('Request.fetchAll aggregates two pages', () async {
    final http = _FakeHttpTwoPages();
    final req = CognitoAdminListUserAuthEventsPaginatorRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
    );

    final all = await req.fetchAll(pageSize: 2);

    expect(all.length, 3);
    expect(all.first['EventId'], 'e1');
    expect(all.last['EventId'], 'e3');
    expect(http.calls, 2); // confirmed pagination
  });
}
