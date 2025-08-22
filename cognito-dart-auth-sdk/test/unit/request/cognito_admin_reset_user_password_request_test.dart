import 'dart:convert';

import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_reset_user_password_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttpClient implements CognitoHttpClient {
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
  test(
    'Request.execute sends correct target/payload and returns success',
    () async {
      final fake = _FakeHttpClient();

      final req = CognitoAdminResetUserPasswordRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        clientMetadata: const {'MyTestKey': 'MyTestValue'},
        region: 'us-west-2',
        httpClient: fake,
      );

      final result = await req.execute();

      expect(result, isA<CognitoAdminResetUserPasswordResult>());
      expect(fake.lastService, 'cognito-idp');
      expect(
        fake.lastTarget,
        'AWSCognitoIdentityProviderService.AdminResetUserPassword',
      );
      expect(fake.lastRegion, 'us-west-2');
      expect(fake.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(fake.lastPayload!['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(fake.lastPayload!['Username'], 'testuser');
      expect(fake.lastPayload!['ClientMetadata'], {'MyTestKey': 'MyTestValue'});

      expect(fake.lastTimeout, isNotNull);
    },
  );
}
