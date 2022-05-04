// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solar_on/Screens/system_select.dart';
import 'package:solar_on/reusables.dart';

class ChangeDetails extends StatefulWidget {
  const ChangeDetails({Key? key}) : super(key: key);
  static const String id = 'change_details';

  @override
  _ChangeDetailsState createState() => _ChangeDetailsState();
}

class _ChangeDetailsState extends State<ChangeDetails> {
  late FocusNode myFocusNode;
  final _formKey = new GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String name = '';
  late String phoneNumber = '';
  late String email = '';

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
      appBar: logoAndPhone(context),
      body: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Flexible(
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, RegistrationAndLogIn.id);
                      },
                      child: GoldLogoImage(height: 250),
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
                            'New Name', 'Alphabetic Characters only (A-Z)'),
                        keyboardType: TextInputType.name,
                        cursorColor: kGoldColor,
                        validator: (text) {
                          if (text != null) {
                            if (text.isNotEmpty && text.length >= 2) {
                              return null;
                            } else if (text.length < 2 && text.isNotEmpty) {
                              return 'Too short';
                            } else if (text
                                .contains('@#\$%^&*()_+!~`=-\'\\;:.,')) {
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
                        decoration: kMyTextDecoration('New phone number',
                            'e.g. +254712345678 (no spaces)'),
                        keyboardType: TextInputType.phone,
                        cursorColor: kGoldColor,
                        validator: (text) {
                          if (text != null) {
                            if (text.isNotEmpty &&
                                text.length == 13 &&
                                text.contains('+')) {
                              return null;
                            } else if (text
                                .contains(' @#\$%^&*()_!~`=-\'\\;:.,')) {
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
                            'New email address', 'e.g. example@example.com'),
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
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width) / 4,
                        right: (MediaQuery.of(context).size.width) / 4,
                      ),
                      child: Button1(
                        text: 'Submit',
                        onPress: () async {
                          if (_formKey.currentState!.validate() &&
                              name != '' &&
                              phoneNumber != '' &&
                              email != '') {
                            try {
                              // await _auth.createUserWithEmailAndPassword(
                              //   email: email,
                              //   password: password1,
                              // );
                              _auth.currentUser!.updateDisplayName(name);
                              _auth.currentUser!.updateEmail(email);
                              print('Update 1');

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
                              print('Update 2');
                              Navigator.pushReplacementNamed(
                                  context, HomePage.id);
                            } catch (error) {
                              print(error);
                              showAlertDialog(context, "Error", "$error");
                            }
                          } else
                            showAlertDialog(
                                context, "Error", "Check entries again");
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
          ],
        ),
      ),
    );
  }
}
