import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthMethods _authMethods =AuthMethods();


  TextEditingController textNameController=TextEditingController();
  TextEditingController textPasswordController=TextEditingController();
  TextEditingController textPhoneController=TextEditingController();
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
          maxLength: 10,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty&&value.length<6) {
              return 'Invalid PhoneNo';
            }
            return null;
          },
          controller: textPhoneController,
          decoration: InputDecoration(
              hintText: "PhoneNo"
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
//        FlatButton.icon(onPressed: gotoLoginPage(), icon: Icon(Icons.person_add), label: Text("Already Registered ? Click Here..",style:TextStyle(color: Colors.black45,)),)
      ],
    );
  }

  gotoLoginPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }
  gotoHomePage(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }
  validateForm()async{
    setState(() {
      isLoginPressed=true;
    });
    if(_formKey.currentState.validate()){

      String userName=textNameController.text;
      String phone=textPhoneController.text;
      String password=textPasswordController.text;

      FirebaseUser currentUser=await _authMethods.handleSignUp(phone,userName, password).then((FirebaseUser user) async{
         await _authMethods.addDataToDb(user,userName,phone,password);
         gotoHomePage();
//        Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()));
      }).catchError((e) => print(e));

      setState(() {
        isLoginPressed=false;
      });

      print(currentUser.email);


    }
  }

}