import 'package:bot_toast/bot_toast.dart';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

class UnlinkProviderScreenViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> unLinkProvider(String providerId) async {
    try {
      setLoading(true);

      await cognitoApp.cognitoAuth?.unlinkProvider(providerId);

      BotToast.showText(text: 'Provider Unlinked Successfully');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
