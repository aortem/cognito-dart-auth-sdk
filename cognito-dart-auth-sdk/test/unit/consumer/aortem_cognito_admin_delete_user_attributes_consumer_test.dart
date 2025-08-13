import 'package:cognito_dart_auth_sdk/consumers/aortem_cognito_admin_delete_user_attributes_consumer.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_http_client.dart';
import 'package:cognito_dart_auth_sdk/exceptions/aortem_cognito_validate_exception.dart';
import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_delete_user_attributes_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class _FakeHttp implements AortemCognitoHttpClient {
  Map<String, dynamic>? lastPayload;
  String? lastTarget;
  String? lastRegion;
  Map<String, String>? lastHeaders;

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
    lastTarget = target;
    lastRegion = region;
    lastHeaders = headers;
    lastPayload = payload;

    return AortemCognitoHttpResponse(
      statusCode: statusCode,
      headers: const {},
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
  group('AdminDeleteUserAttributesConsumer', () {
    test('happy path: builds and sends payload with attribute names', () async {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminDeleteUserAttributesConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      final res = await consumer.run(
        (b) => b
          ..userPoolId('us-west-2_EXAMPLE')
          ..username('testuser')
          ..attributes(['custom:deliverables', 'nickname']),
      );

      expect(res, isA<AortemCognitoAdminDeleteUserAttributesResult>());

      // Verify payload + target + headers
      final p = http.lastPayload!;
      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminDeleteUserAttributes',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['UserAttributeNames'], ['custom:deliverables', 'nickname']);
    });

    test('missing requireds throw before HTTP', () {
      final http = _FakeHttp();
      final consumer = AortemCognitoAdminDeleteUserAttributesConsumer(
        region: 'us-west-2',
        httpClient: http,
      );

      // Missing username
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..attributes(['nickname']),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing userPoolId
      expect(
        () => consumer.run(
          (b) => b
            ..username('user')
            ..attributes(['nickname']),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // Missing attributes
      expect(
        () => consumer.run(
          (b) => b
            ..userPoolId('us-west-2_EXAMPLE')
            ..username('user'),
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });
  });
}
