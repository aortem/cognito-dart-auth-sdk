import 'package:cognito_dart_auth_sdk/consumers/cognito_admin_get_user_consumer.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

// Adjust imports to your package paths.
import 'package:cognito_dart_auth_sdk/requests/cognito_admin_get_user_request.dart';
import 'package:cognito_dart_auth_sdk/requests/cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/cognito_validate_exception.dart';

class _FakeHttp implements CognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

  int statusCode = 200;
  String bodyString = '''
{
  "Enabled": true,
  "UserAttributes": [
    {"Name":"email","Value":"demo@example.com"}
  ],
  "Username": "demo"
}
''';

  @override
  Future<CognitoHttpResponse> send({
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

    return CognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
      bodyString: bodyString,
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
  group('AdminGetUserConsumer (Ticket #24)', () {
    test('happy path: builds, sends, and parses user', () async {
      final http = _FakeHttp();

      final consumer = CognitoAdminGetUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('demo'),
      );

      expect(res, isA<CognitoAdminGetUserResult>());
      expect(res.user.username, 'demo');
      expect(res.user.attributes['email'], 'demo@example.com');

      final p = http.lastPayload!;
      expect(http.lastTarget, 'AWSCognitoIdentityProviderService.AdminGetUser');
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'demo');
    });

    test('missing requireds throw before HTTP', () {
      final http = _FakeHttp();
      final consumer = CognitoAdminGetUserConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // Missing username
      expect(
        () => consumer.run((b) => b..userPoolId('us-west-2_EXAMPLE')),
        throwsA(isA<CognitoValidationException>()),
      );

      // Missing pool id
      expect(
        () => consumer.run((b) => b..username('demo')),
        throwsA(isA<CognitoValidationException>()),
      );
    });
  });
}
