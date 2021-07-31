/*
 * Copyright (c) 2021 Akshay Jadhav <jadhavakshay0701@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';

class LoginPageBloc with ChangeNotifier {

  AuthMethods mAuthMethods = AuthMethods();

  bool isLoginPressed = false;

  String validateEmail(String email) {
    if (email.isEmpty && EmailValidator.validate(email)) {
      return 'Please enter valid email';
    }
    return null;
  } 

  String validatePassword(String password) {
    if (password.isEmpty && password.length<6) {
      return 'Password should atleast contain 6 character';
    }
    return null;
  } 

  Future<void> validateFormAndLogin(GlobalKey<FormState> formKey, String userName, String password) async {
      isLoginPressed=true;
      notifyListeners();
      if(formKey.currentState.validate()){
          await mAuthMethods.handleSignInEmail(userName, password);
          isLoginPressed=false;
          notifyListeners();
      }
  }
}