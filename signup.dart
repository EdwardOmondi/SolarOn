// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solar_on/Screens/system_select.dart';
import 'package:solar_on/Screens/registrationandlogin.dart';
import 'package:solar_on/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);
  static const String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String name = '';
  late String phoneNumber = '';
  late String email = '';
  late String password1 = '';
  late String password2 = '';
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
      body: ModalProgressHUD(
        color: kGoldColor,
        inAsyncCall: showSpinner,
        child: Material(
          child: Form(
            key: _formKey,
            //autovalidate: _autoValidate,
            child: ListView(
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationAndLogIn.id);
                  },
                  child: Hero(tag: kLogoTag, child: GoldLogoImage(height: 250)),
                ),
                SizedBox(
                  height: 10.0,
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
                    decoration: kMyTextDecoration(
                        'Full Name', 'Alphabetic Characters only (A-Z)'),
                    keyboardType: TextInputType.name,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty && text.length >= 2) {
                          return null;
                        } else if (text.length < 2 && text.isNotEmpty) {
                          return 'Too short';
                        } else if (text.contains('@#\$%^&*()_+!~`=-\'\\;:.,')) {
                          return 'Alphabetic characters only';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ), //Name text box
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
                    decoration: kMyTextDecoration('Enter your phone number',
                        'e.g. +254712345678 (no spaces)'),
                    keyboardType: TextInputType.phone,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty &&
                            text.length == 13 &&
                            text.contains('+')) {
                          return null;
                        } else if (text.contains(' @#\$%^&*()_!~`=-\'\\;:.,')) {
                          return 'Invalid phone number';
                        } else if (text.length < 10 && text.isNotEmpty) {
                          return 'Invalid phone number';
                        } else if (text.length > 10 && text.isNotEmpty) {
                          return 'Invalid phone number';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                  ),
                ), //Phone number text box,
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
                        } else if (text.isEmpty) {
                          return '*Required';
                        } else {
                          return '*Invalid email';
                        }
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ), //Email address text box,
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
                    decoration: kMyTextDecoration(
                        'Enter your password', 'Must be at least 6 characters'),
                    obscureText: true,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty && text.length >= 6) {
                          return null;
                        } else if (text.length < 5 && text.isNotEmpty) {
                          return 'Password is too Short';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (content) {
                      password1 = content;
                    },
                  ),
                ), //Password 1 text box
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
                    decoration: kMyTextDecoration('Re-enter your password',
                        'Must match with the one above'),
                    obscureText: true,
                    cursorColor: kGoldColor,
                    validator: (text) {
                      if (text != null) {
                        if (text.isNotEmpty &&
                            text.length >= 6 &&
                            text == password1) {
                          return null;
                        } else if (text != password1) {
                          return 'Passwords do not match';
                        } else if (text.length < 5 && text.isNotEmpty) {
                          return 'Password is too Short';
                        } else {
                          return '*Required';
                        }
                      }
                    },
                    onChanged: (content) {
                      password2 = content;
                    },
                  ),
                ), // Password 2 text box
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width) / 4,
                    right: (MediaQuery.of(context).size.width) / 4,
                  ),
                  child: Button1(
                    text: 'Sign Up',
                    onPress: () async {
                      if (_formKey.currentState!.validate() &&
                          name != '' &&
                          phoneNumber != '' &&
                          email != '' &&
                          password1 != '') {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password1);
                          _auth.currentUser!.updateDisplayName(name);

                          _firestore
                              .collection('users')
                              .doc(email.toString())
                              .set(
                            {
                              'name': name,
                              'email': email,
                              'phone': phoneNumber,
                            },
                          );
                          Navigator.pushReplacementNamed(context, HomePage.id);
                        } catch (error) {
                          print(error);
                          showAlertDialog(
                            context,
                            "Error",
                            '$error',
                          );
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } else
                        setState(() {
                          _autoValidate = true;
                        });
                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          _autoValidate = false;
                        });
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).size.height) / 20,
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
