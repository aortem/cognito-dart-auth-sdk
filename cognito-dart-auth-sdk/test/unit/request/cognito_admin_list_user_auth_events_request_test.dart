import 'dart:convert';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/cognito_admin_list_user_auth_events_request.dart';
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
      // Page 1 with NextToken
      return CognitoHttpResponse(
        statusCode: 200,
        headers: const {},
        bodyString: jsonEncode({
          'AuthEvents': [
            {'EventId': 'E1', 'EventType': 'SignIn'},
          ],
          'NextToken': 'TOKEN-2',
        }),
      );
    }
    // Page 2 no NextToken
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({
        'AuthEvents': [
          {'EventId': 'E2', 'EventType': 'SignIn'},
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
  test('listAll aggregates events across pages', () async {
    final http = _FakeHttp();
    final req = CognitoAdminListUserAuthEventsRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
      maxResults: 2,
    );

    final events = await req.listAll();
    expect(events, hasLength(2));
    expect(events.first['EventId'], 'E1');
    expect(events.last['EventId'], 'E2');
    expect(http.calls, 2);
  });

  test('paginate yields two pages', () async {
    final http = _FakeHttp();
    final req = CognitoAdminListUserAuthEventsRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      region: 'us-west-2',
      httpClient: http,
      maxResults: 1,
    );

    final pages = <CognitoAdminListUserAuthEventsPage>[];
    await for (final p in req.paginate()) {
      pages.add(p);
    }

    expect(pages, hasLength(2));
    expect(pages[0].authEvents.first['EventId'], 'E1');
    expect(pages[1].authEvents.first['EventId'], 'E2');
  });
}
