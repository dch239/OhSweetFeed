import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/constants.dart';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'package:ohhsweetfeed/tools/firebase_methods.dart';
import 'package:ohhsweetfeed/user_screens/singup.dart';

class SignupFormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupFormScreenState();
  }
}

class SignupFormScreenState extends State<SignupFormScreen> {
  String _name;
  String _email;
  String _password;
  String _phoneNumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppMethods appMethods = FirebaseMethods();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

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

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.length != 10) {
          return 'Please enter a valid phone number.';
        }

        return null;
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildPhoneNumber(),
                _buildEmail(),
                _buildPassword(),
                SizedBox(height: 20),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();
                    displayProgressDialog(context);
                    String response = await appMethods.createUserAccount(
                        name: _name,
                        phone: _phoneNumber,
                        email: _email,
                        password: _password);
                    print(response);

                    closeProgressDialog(context);
                    showSnackBar(message: response, scaffoldKey: scaffoldKey);
                    if (response == kSignUpSuccessMessage) {
                      Navigator.pop(context, true);
                    }

                    print(_name);
                    print(_email);
                    print(_phoneNumber);
                    print(_password);

                    //Send to API
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
