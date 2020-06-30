import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';

void main() {
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
//      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
    );
  }
}
