import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

///connect auth class
class ConnectAuthEmulatorService {
  ///auth instance
  final cognitoAuth auth;

  ///connect auth service
  ConnectAuthEmulatorService(this.auth);

  ///connect auth function
  void connect(String host, int port) {
    final url = 'http://$host:$port';
    auth.setEmulatorUrl(url);
    print('Connected to cognito Auth Emulator at $url');
  }
}
