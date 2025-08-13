import 'package:test/test.dart';

// SDK imports (adjust the package path if your pubspec uses a different name)
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_add_user_to_group_request.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_service_exception.dart';

/// Minimal fake HTTP client that records the last payload and returns a canned response.
class _FakeHttpClient implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  int statusCode = 200;
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
    lastPayload = payload;
    return AortemCognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
    );
  }

  // If your interface also requires post(...), keep it here for compatibility.
  @override
  Future<AortemCognitoHttpResponse> post({
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
  group('AortemCognitoAdminAddUserToGroupRequest (simple)', () {
    test('happy path: builds payload and returns success on 200', () async {
      final http = _FakeHttpClient();
      final req = AortemCognitoAdminAddUserToGroupRequest(
        userPoolId: 'ap-south-1_ABC123',
        username: 'jane.doe',
        groupName: 'Admins',
        region: 'ap-south-1',
        httpClient: http,
      );

      final result = await req.execute();
      expect(result, isA<AortemCognitoAdminAddUserToGroupResult>());

      final payload = http.lastPayload!;
      expect(payload['UserPoolId'], 'ap-south-1_ABC123');
      expect(payload['Username'], 'jane.doe');
      expect(payload['GroupName'], 'Admins');
    });

    test(
      'validation: bad userPoolId pattern throws AortemCognitoValidationException',
      () {
        final http = _FakeHttpClient();
        expect(
          () => AortemCognitoAdminAddUserToGroupRequest(
            userPoolId: 'badPoolId',
            username: 'john',
            groupName: 'Users',
            region: 'ap-south-1',
            httpClient: http,
          ),
          throwsA(isA<AortemCognitoValidationException>()),
        );
      },
    );

    test('4xx response throws AortemCognitoServiceException', () async {
      final http = _FakeHttpClient()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';
      final req = AortemCognitoAdminAddUserToGroupRequest(
        userPoolId: 'ap-south-1_POOL',
        username: 'john',
        groupName: 'Users',
        region: 'ap-south-1',
        httpClient: http,
        maxRetries: 0, // fail fast for the test
      );

      expect(
        () => req.execute(),
        throwsA(isA<AortemCognitoServiceException>()),
      );
    });
  });
}
