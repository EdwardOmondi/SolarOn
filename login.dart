// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:solar_on/Screens/TestScreen.dart';
import 'package:solar_on/Screens/forgot_password.dart';
import 'package:solar_on/reusables.dart';
import 'package:solar_on/Screens/system_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solar_on/Screens/signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogIn extends StatefulWidget {
  LogIn({Key? key}) : super(key: key);
  static const String id = 'log_in';

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "edward@mmw.co.ke";
  late String password;
  late FocusNode myFocusNode;
  // ignore: unused_field
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Material(
          child: Form(
            key: _formKey,
            //autovalidate: _autoValidate,
            child: ListView(
              children: [
                MaterialButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, RegistrationAndLogIn.id);
                    Navigator.pushNamed(context, TestPage.id);
                  },
                  child: Hero(tag: kLogoTag, child: GoldLogoImage(height: 250)),
                ),

                SizedBox(
                  height: 24.0,
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width) / 8,
                    right: (MediaQuery.of(context).size.width) / 8,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xff000000),
                    ),
                    decoration: kMyTextDecoration(
                        'Enter your email address', 'e.g. example@example.com'),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty &&
                            text.length > 5 &&
                            text.contains('@')) {
                          return null;
                        } else if (!text.isNotEmpty) {
                          return '*Required';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                //Email address text box,
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width) / 8,
                    right: (MediaQuery.of(context).size.width) / 8,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: kMyTextDecoration('Enter your Password',
                        'Must be at least 6 characters long'),
                    obscureText: true,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty && text.length >= 6) {
                          return null;
                        } else if (text.length < 5 && text.isNotEmpty) {
                          return 'Incorrect password';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (content) {
                      password = content;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width) / 4,
                    right: (MediaQuery.of(context).size.width) / 4,
                  ),
                  child: Button1(
                    text: 'Log In',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          Navigator.pushReplacementNamed(context, HomePage.id);
                        } catch (error) {
                          if (error.toString().contains("network error")) {
                            showAlertDialog(
                              context,
                              "Error",
                              "Error connecting to the network. Please try again",
                            );
                          }
                          if (error
                              .toString()
                              .contains("password is invalid")) {
                            showAlertDialog(
                              context,
                              "Error",
                              "Invalid password or wrong email address.",
                            );
                          }
                          if (error.toString().contains("user-not-found")) {
                            showAlertDialog(
                              context,
                              "Error",
                              "This user has not been found. Kindly sign up to use SolarOn",
                            );
                          }
                          if (error.toString().contains("invalid-email")) {
                            showAlertDialog(
                              context,
                              "Error",
                              "Kindly check your email address.",
                            );
                          }
                          if (error.toString().contains("too-many-requests")) {
                            showAlertDialog(
                              context,
                              "Error",
                              "We have blocked all requests from this device due to unusual activity. Try again later.",
                            );
                          }
                          print(error);

                          setState(() {
                            showSpinner = false;
                          });
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } else
                        setState(() {
                          _autoValidate = true;
                        });

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       'Check entries again',
                      //       style: TextStyle(
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //     backgroundColor: Colors.white,
                      //     duration: snackbarDisplayDuration,
                      //   ),
                      // );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ForgotPassword.id);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: kMyTextStyleGold(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.id);

                    print('pressed');
                  },
                  child: Text(
                    'Sign up',
                    style: kMyTextStyleGold(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
