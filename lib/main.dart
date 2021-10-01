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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/AuthMethods.dart';
import 'package:food_delivery_app/screens/HomePage.dart';
import 'package:food_delivery_app/screens/LoginPages/LoginPage.dart';
import 'package:food_delivery_app/utils/UniversalVariables.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: UniversalVariables.orangeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, appSnapshot) {
          // Check for errors
          if (appSnapshot.hasError) {
            return Center(
              child: Text('Something went wrong during Firebase Initialization!'),
            );
          }

          // Once complete, show your application
          if (appSnapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<User>(
              future: _authMethods.getCurrentUser(),
              builder: (context, AsyncSnapshot<User> userSnapshot) {
                if (userSnapshot.hasData) {
                  return HomePage();
                } else {
                  return LoginPage();
                }
              },
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
