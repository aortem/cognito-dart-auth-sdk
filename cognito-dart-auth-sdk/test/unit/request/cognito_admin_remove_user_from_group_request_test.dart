import 'dart:convert';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_remove_user_from_group_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttpClient implements CognitoHttpClient {
  // Captured inputs for assertions
  String? lastService;
  String? lastTarget;
  String? lastRegion;
  Map<String, dynamic>? lastPayload;
  Map<String, String>? lastHeaders;
  Duration? lastTimeout;

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastService = service;
    lastTarget = target;
    lastRegion = region;
    lastPayload = payload;
    lastHeaders = headers;
    lastTimeout = timeout;

    // Return happy-path 200 with empty body
    return CognitoHttpResponse(
      statusCode: 200,
      headers: const {},
      bodyString: jsonEncode({}),
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
    // Not used by this request; route to send to be safe.
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
  test('Request.execute posts correct payload and returns success', () async {
    final fake = _FakeHttpClient();

    final req = CognitoAdminRemoveUserFromGroupRequest(
      userPoolId: 'us-west-2_EXAMPLE',
      username: 'testuser',
      groupName: 'MyExampleGroup1',
      region: 'us-west-2',
      httpClient: fake,
    );

    final result = await req.execute();

    // type check
    expect(result, isA<CognitoAdminRemoveUserFromGroupResult>());

    // call assertions
    expect(fake.lastService, 'cognito-idp');
    expect(
      fake.lastTarget,
      'AWSCognitoIdentityProviderService.AdminRemoveUserFromGroup',
    );
    expect(fake.lastRegion, 'us-west-2');
    expect(fake.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

    // payload assertions
    expect(fake.lastPayload, isNotNull);
    expect(fake.lastPayload!['UserPoolId'], 'us-west-2_EXAMPLE');
    expect(fake.lastPayload!['Username'], 'testuser');
    expect(fake.lastPayload!['GroupName'], 'MyExampleGroup1');

    // sane timeout default behavior
    expect(fake.lastTimeout, isNotNull);
  });
}
