import 'package:ds_tools_testing/ds_tools_testing.dart';

// SDK imports (adjust the package path if your pubspec uses a different name)
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_add_user_to_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_service_exception.dart';

/// Minimal fake HTTP client that records the last payload and returns a canned response.
class _FakeHttpClient implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  int statusCode = 200;
  String bodyString = '{}';

  @override
  Future<CognitoHttpResponse> send({
    required String service,
    required String target,
    required String region,
    required Map<String, dynamic> payload,
    required Duration timeout,
    Map<String, String>? headers,
  }) async {
    lastPayload = payload;
    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  // If your interface also requires post(...), keep it here for compatibility.
  @override
  Future<CognitoHttpResponse> post({
    required String region,
    required String xAmzTarget,
    required Map<String, dynamic> payload,
    Map<String, String>? additionalHeaders,
    Duration? timeout,
  }) {
    // Delegate to send() so either signature works in tests.
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
  group('   CognitoAdminAddUserToGroupRequest (simple)', () {
    test('happy path: builds payload and returns success on 200', () async {
      final http = _FakeHttpClient();
      final req = CognitoAdminAddUserToGroupRequest(
        userPoolId: 'ap-south-1_ABC123',
        username: 'jane.doe',
        groupName: 'Admins',
        region: 'ap-south-1',
        httpClient: http,
      );

      final result = await req.execute();
      expect(result, isA<CognitoAdminAddUserToGroupResult>());

      final payload = http.lastPayload!;
      expect(payload['UserPoolId'], 'ap-south-1_ABC123');
      expect(payload['Username'], 'jane.doe');
      expect(payload['GroupName'], 'Admins');
    });

    test(
      'validation: bad userPoolId pattern throws    CognitoValidationException',
      () {
        final http = _FakeHttpClient();
        expect(
          () => CognitoAdminAddUserToGroupRequest(
            userPoolId: 'badPoolId',
            username: 'john',
            groupName: 'Users',
            region: 'ap-south-1',
            httpClient: http,
          ),
          throwsA(isA<CognitoValidationException>()),
        );
      },
    );

    test('4xx response throws    CognitoServiceException', () async {
      final http = _FakeHttpClient()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';
      final req = CognitoAdminAddUserToGroupRequest(
        userPoolId: 'ap-south-1_POOL',
        username: 'john',
        groupName: 'Users',
        region: 'ap-south-1',
        httpClient: http,
        maxRetries: 0, // fail fast for the test
      );

      expect(() => req.execute(), throwsA(isA<CognitoServiceException>()));
    });
  });
}
