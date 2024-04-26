

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';

class LoginPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();

  bool isLoginPressed = false;

  String? validateEmail(String email) {
    if (email.isEmpty && EmailValidator.validate(email)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty && password.length < 6) {
      return 'Password should atleast contain 6 character';
    }
    return null;
  }

  Future<void> validateFormAndLogin(
      GlobalKey<FormState> formKey, String userName, String password) async {
    isLoginPressed = true;
    notifyListeners();
    if (formKey.currentState?.validate() == true) {
      await mAuthMethods.handleSignInEmail(userName, password);
      isLoginPressed = false;
      notifyListeners();
    }
  }
}
