import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/admin_screens/admin_home.dart';
import 'package:ohhsweetfeed/constants.dart';
import 'package:ohhsweetfeed/tools/app_data.dart';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'package:ohhsweetfeed/tools/firebase_methods.dart';
import 'package:ohhsweetfeed/user_screens/signup_form.dart';
import 'package:ohhsweetfeed/user_screens/singup.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppMethods appMethods = FirebaseMethods();

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password', errorMaxLines: 3),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        if (!RegExp(
                r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
            .hasMatch(value)) {
          return ' Your password must be more than 8 characters long, should contain at-least 1 Uppercase, 1 Lowercase, 1 Numeric and 1 special character.';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildEmail(),
                _buildPassword(),
                SizedBox(height: 40),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();
                    displayProgressDialog(context);
                    String response = await appMethods.loginUser(
                        email: _email, password: _password);

                    closeProgressDialog(context);
                    showSnackBar(message: response, scaffoldKey: scaffoldKey);
                    bool isAccountAdmin =
                        await getBoolDataLocally(key: userIsAdmin);

                    if (response == kSignInSuccessMessage &&
                        isAccountAdmin == false) {
                      Navigator.pop(context, true);
                    }
                    if (response == kSignInSuccessMessage &&
                        isAccountAdmin == true) {
                      print("inside");
                      print(isAccountAdmin);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminHome()));
                    }

                    print(_email);
                    print(_password);

                    //Send to API
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    "Not Registered? Sign Up Here!",
                    textAlign: TextAlign.center,
                  ),
                  onTap: () async {
                    bool response = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupFormScreen()));
                    if (response == true) {
                      showSnackBar(
                          scaffoldKey: scaffoldKey,
                          message:
                              "Signed Up Successfully. Please verify your mail and login.");
                      _formKey.currentState.reset();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
