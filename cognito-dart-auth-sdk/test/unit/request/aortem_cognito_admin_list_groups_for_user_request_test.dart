import 'dart:convert';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_list_groups_for_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  Map<String, String> headers = const {};
  String bodyString = '{}';

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
  group('AdminListGroupsForUserRequest (Ticket #31)', () {
    test('happy path: parses groups & next token', () async {
      final http = _FakeHttp()
        ..bodyString = jsonEncode({
          'Groups': [
            {
              'GroupName': 'Admins',
              'Description': 'Admin group',
              'UserPoolId': 'us-west-2_EXAMPLE',
            },
            {'GroupName': 'Editors', 'UserPoolId': 'us-west-2_EXAMPLE'},
          ],
          'NextToken': 'NEXT123',
        });

      final req = AortemCognitoAdminListGroupsForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
        limit: 2,
      );

      final res = await req.execute();
      expect(res.groups, hasLength(2));
      expect(res.groups.first['GroupName'], 'Admins');
      expect(res.nextToken, 'NEXT123');

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
      expect(p.containsKey('NextToken'), isFalse);
    });

    test('validation: pool id/limit/token checks', () {
      final http = _FakeHttp();

      // bad pool id
      expect(
        () => AortemCognitoAdminListGroupsForUserRequest(
          userPoolId: 'bad',
          username: 'u',
          region: 'r',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // limit > 60
      expect(
        () => AortemCognitoAdminListGroupsForUserRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'u',
          region: 'us-west-2',
          httpClient: http,
          limit: 61,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // whitespace token
      expect(
        () => AortemCognitoAdminListGroupsForUserRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'u',
          region: 'us-west-2',
          httpClient: http,
          nextToken: '   ',
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx -> service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';

      final req = AortemCognitoAdminListGroupsForUserRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
        maxRetries: 0,
      );

      expect(
        () => req.execute(),
        throwsA(isA<AortemCognitoServiceException>()),
      );
    });
  });
}
