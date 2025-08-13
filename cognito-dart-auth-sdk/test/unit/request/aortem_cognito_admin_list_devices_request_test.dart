import 'dart:convert';
import 'package:test/test.dart';

import 'package:cognito_dart_auth_sdk/requests/aortem_cognito_admin_list_devices_request.dart';
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
  group('AdminListDevicesRequest (Ticket #29)', () {
    test('happy path: parses devices & pagination token', () async {
      final http = _FakeHttp()
        ..bodyString = jsonEncode({
          'Devices': [
            {
              'DeviceKey': 'key-1',
              'DeviceAttributes': [
                {'Name': 'device_name', 'Value': 'Dart-device'},
              ],
              'DeviceCreateDate': 1715100742.022,
            },
          ],
          'PaginationToken': 'NEXT',
        });

      final req = AortemCognitoAdminListDevicesRequest(
        userPoolId: 'us-west-2_EXAMPLE',
        username: 'testuser',
        region: 'us-west-2',
        httpClient: http,
        limit: 2,
      );

      final res = await req.execute();
      expect(res.devices, hasLength(1));
      expect(res.devices.first['DeviceKey'], 'key-1');
      expect(res.paginationToken, 'NEXT');

      expect(
        http.lastTarget,
        'AWSCognitoIdentityProviderService.AdminListDevices',
      );
      expect(http.lastRegion, 'us-west-2');
      expect(http.lastHeaders?['Content-Type'], 'application/x-amz-json-1.1');

      final p = http.lastPayload!;
      expect(p['UserPoolId'], 'us-west-2_EXAMPLE');
      expect(p['Username'], 'testuser');
      expect(p['Limit'], 2);
      expect(p.containsKey('PaginationToken'), isFalse);
    });

    test('validation: bad pool id, bad limit, bad token', () {
      final http = _FakeHttp();

      // bad pool id pattern
      expect(
        () => AortemCognitoAdminListDevicesRequest(
          userPoolId: 'bad',
          username: 'u',
          region: 'us',
          httpClient: http,
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );

      // limit > 60
      expect(
        () => AortemCognitoAdminListDevicesRequest(
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
        () => AortemCognitoAdminListDevicesRequest(
          userPoolId: 'us-west-2_EXAMPLE',
          username: 'u',
          region: 'us-west-2',
          httpClient: http,
          paginationToken: '   ',
        ),
        throwsA(isA<AortemCognitoValidationException>()),
      );
    });

    test('4xx -> service exception', () async {
      final http = _FakeHttp()
        ..statusCode = 400
        ..bodyString = '{"message":"InvalidParameterException"}';

      final req = AortemCognitoAdminListDevicesRequest(
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
