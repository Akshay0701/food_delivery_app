import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthMethods _authMethods =AuthMethods();


  TextEditingController textNameController=TextEditingController();
  TextEditingController textPasswordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //loading
  bool isLoginPressed = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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
        FlutterLogo(size: 200.0,),
        SizedBox(height:20.0),
        TextFormField(
          validator: (value) {
            if (value.isEmpty&&EmailValidator.validate(value)) {
              return 'Please enter valid email';
            }
            return null;
          },
          controller: textNameController,
          decoration: InputDecoration(
              hintText: "Email"
          ),
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty&&value.length<6) {
              return 'Password should atleast contain 6 character';
            }
            return null;
          },
          controller: textPasswordController,
          decoration: InputDecoration(
              hintText: "Password"
          ),
        ),
        SizedBox(height:20.0),
        RaisedButton(
          color: Colors.orangeAccent,
          onPressed: ()=>validateForm(),
          child: Text("Login",style:TextStyle(color: Colors.white,)),
        ),
        isLoginPressed
        ? Center(
        child: CircularProgressIndicator())
        :Container(),
      FlatButton.icon(onPressed:()=> gotoRegisterPage(), icon: Icon(Icons.person_add), label: Text("New User ? Click Here..",style:TextStyle(color: Colors.black45,)),)
      ],
    );
  }

  gotoRegisterPage(){
   Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>RegisterPage()));
  }
  validateForm()async{
    setState(() {
      isLoginPressed=true;
    });
   if(_formKey.currentState.validate()){

     String userName=textNameController.text;
     String password=textPasswordController.text;

      FirebaseUser currentUser=await _authMethods.handleSignInEmail(userName, password).then((FirebaseUser user) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()));
      }).catchError((e) => print(e));

      setState(() {
        isLoginPressed=false;
      });

      print(currentUser.email);


   }
  }

}