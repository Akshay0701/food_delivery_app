

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/blocs/RegisterPageBloc.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterPageBloc(), child: RegisterPageContent());
  }
}

class RegisterPageContent extends StatefulWidget {
  @override
  _RegisterPageContentState createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<RegisterPageContent> {
  late RegisterPageBloc registerPageBloc;

  TextEditingController textNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController textPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: // do we need to keep this here or in didChangeDependencies
    registerPageBloc = Provider.of<RegisterPageBloc>(context);
    return Scaffold(
      body: Container(
        color: UniversalVariables.whiteColor,
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: buildForm(),
        ),
      ),
    );
  }

  buildForm() {
    return Column(
      children: [
        SizedBox(height: 20.0),
        FlutterLogo(
          size: 200.0,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          validator: (email) {
            return registerPageBloc.validateEmail(email ?? '');
          },
          controller: textNameController,
          decoration: InputDecoration(hintText: "Email"),
        ),
        TextFormField(
          maxLength: 10,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          validator: (phone) {
            return registerPageBloc.validatePhone(phone ?? '');
          },
          controller: textPhoneController,
          decoration: InputDecoration(hintText: "PhoneNo"),
        ),
        TextFormField(
          validator: (password) {
            return registerPageBloc.validatePassword(password ?? '');
          },
          controller: textPasswordController,
          decoration: InputDecoration(hintText: "Password"),
        ),
        SizedBox(height: 20.0),
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(UniversalVariables.orangeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
          ),
          onPressed: () {
            registerPageBloc
                .validateFormAndRegister(_formKey, textNameController.text,
                    textPasswordController.text, textPhoneController.text)
                .then((_) => gotoHomePage());
          },
          child: Text("Register",
              style: TextStyle(
                color: UniversalVariables.whiteColor,
              )),
        ),
        registerPageBloc.isRegisterPressed
            ? Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }

  gotoLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  gotoHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
