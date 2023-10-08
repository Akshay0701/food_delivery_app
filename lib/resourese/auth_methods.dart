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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/user_model.dart';

class AuthMethods {
  // Firebase auth, will use to get user info and registration and signing
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _userReference =
      _database.reference().child("Users");

  // current user getter
  Future<User> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser!;
  }

  // gets auth state of user through out the life cycle of the app
  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges().map((user) => user);
  }

  //sign in current user with email and password
  Future<UserCredential> handleSignInEmail(
      String email, String password) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);

    assert(userCredential.user != null);
    final User? currentUser = _auth.currentUser;
    assert(userCredential.user?.uid == currentUser?.uid);

    print('signInEmail succeeded: $userCredential');

    return userCredential;
  }

  // register new user with phone email password details
  Future<UserCredential> handleSignUp(phone, email, password) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await addDataToDb(userCredential.user!, email, phone, password);
    }
    return userCredential;
  }

  // after sign up, add user data to firebase realtime database
  Future<void> addDataToDb(
      User currentUser, String username, String phone, String password) async {
    UserModel user = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        phone: phone,
        password: password);

    _userReference.child(currentUser.uid).set(user.toMap(user));
  }

  // Logs out current user from the application
  Future<void> logout() async {
    await _auth.signOut();
  }
}
