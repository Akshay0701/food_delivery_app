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

import 'package:flutter/material.dart';
import 'package:food_delivery_app/blocs/LoginPageBloc.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/register.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginPageBloc(),
      child: LoginPageContent()
    );
  }
}

class LoginPageContent extends StatefulWidget {
  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {

  TextEditingController textNameController=TextEditingController();
  TextEditingController textPasswordController=TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginPageBloc loginPageBloc;

  @override
  Widget build(BuildContext context) {
    loginPageBloc = Provider.of<LoginPageBloc>(context);
    return Scaffold(
      body: Container(
        color: UniversalVariables.whiteColor,
        padding: EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
        child: Form(
          key: _formKey,
          child: buildForm(),
        ),
      ),
    );
  }


  buildForm(){
    return Column(
      children:[
        SizedBox(height:20.0),
        Hero(
          tag: 'hero',
          child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/logo.jpg'),
          ),
        ),
        SizedBox(height:20.0),
        TextFormField(
            validator: (email) {
              return loginPageBloc.validateEmail(email);
            },
            controller: textNameController,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        TextFormField(
          validator: (password) {
             return loginPageBloc.validateEmail(password);
          },
          controller: textPasswordController,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.password_outlined),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
        SizedBox(height:50.0),
        SizedBox(
            width: double.infinity,
            child: TextButton(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(UniversalVariables.orangeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),)
            ),),
            onPressed: () => loginPageBloc.validateFormAndLogin(_formKey, textNameController.text, textPasswordController.text).then((_) => gotoHomePage()),
            child: Text("Login",style:TextStyle(color: UniversalVariables.whiteColor,fontSize: 24)),
          ) ,
        ),
        loginPageBloc.isLoginPressed
        ? Center(
        child: CircularProgressIndicator())
        :Container(),
      TextButton.icon(onPressed:()=> gotoRegisterPage(), icon: Icon(Icons.person_add), label: Text("New User ? Click Here..",style:TextStyle(color: Colors.black45, fontWeight: FontWeight.bold)),)
      ],
    );
  }

  gotoHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }

  gotoRegisterPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
  }
}