import 'package:bot_toast/bot_toast.dart';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final cognitoAuth _auth;

  SignUpViewModel(this._auth);

  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> signUp(
    String email,
    String password,
    VoidCallback onSuccess,
  ) async {
    try {
      setLoading(true);

      UserCredential? userCredential =
          await _auth.createUserWithEmailAndPassword(email, password);

      BotToast.showText(text: '${userCredential.user.email} just signed up');
      onSuccess();
    } catch (e) {
      BotToast.showText(text: 'Sign up error: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
