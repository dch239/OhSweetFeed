import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppTextField(
            controller: email,
            textIcon: Icons.email,
            textHint: "Name",
            isPassword: false,
          ),
          AppTextField(
            controller: email,
            textIcon: Icons.email,
            textHint: "Name",
            isPassword: false,
          ),
          AppTextField(
            controller: email,
            textIcon: Icons.email,
            textHint: "Email Address",
            isPassword: false,
          ),
          AppTextField(
            controller: password,
            textIcon: Icons.lock,
            textHint: "Password",
            isPassword: true,
          ),
          appButton(
            btnTxt: "Sign Up",
            btnPadding: 18,
            onClick: verifyDetails,
          ),
        ],
      ),
    );
  }

  verifyDetails() {
    if (email.text.isEmpty)
      showSnackBar(scaffoldKey: scaffoldKey, message: "Email Cannot Be Empty");
    if (password.text.isEmpty)
      showSnackBar(
          scaffoldKey: scaffoldKey, message: "Password Cannot Be Empty");
    else
      displayProgressDialog(context);
  }
}
