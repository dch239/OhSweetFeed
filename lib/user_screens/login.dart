import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'package:ohhsweetfeed/user_screens/singup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
            btnTxt: "Login",
            btnPadding: 18,
            onClick: verifyLogin,
          ),
          GestureDetector(
            child: Text("Click Here To Sign Up"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
          ),
        ],
      ),
    );
  }

  verifyLogin() {
    if (email.text.isEmpty)
      showSnackBar(scaffoldKey: scaffoldKey, message: "Email Cannot Be Empty");
    if (password.text.isEmpty)
      showSnackBar(
          scaffoldKey: scaffoldKey, message: "Password Cannot Be Empty");
    else
      displayProgressDialog(context);
  }
}
