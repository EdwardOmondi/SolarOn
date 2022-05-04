// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/Screens/registrationandlogin.dart';
import 'package:solar_on/Screens/system_select.dart';
import 'package:solar_on/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);
  static const String id = 'forgot_password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String email;
  // ignore: unused_field
  bool _autoValidate = false;

  late FocusNode myFocusNode;

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kScaffoldWhite,
        title: IconButton(
          icon: SvgPicture.asset(
            kLogoGold,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => launch("tel:+254701088334"),
            icon: Icon(
              Icons.phone,
            ),
            tooltip: 'Call and get assistance',
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Material(
        child: Form(
          key: _formKey,
          //autovalidate: _autoValidate,
          child: ListView(
            children: [
              MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationAndLogIn.id);
                  },
                  child:
                      Hero(tag: kLogoTag, child: GoldLogoImage(height: 250))),

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
                        return '*Invalid email';
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
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width) / 6,
                  right: (MediaQuery.of(context).size.width) / 6,
                ),
                child: Button1(
                  text: 'Reset Password',
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _auth.sendPasswordResetEmail(email: email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Success. A reset link has been sent to your email.',
                              style: TextStyle(
                                color: kGoldColor,
                              ),
                            ),
                            backgroundColor: kScaffoldWhite,
                            duration: Duration(
                              seconds: 5,
                            ),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, LogIn.id);
                      } catch (error) {
                        if (error.toString().contains("user-not-found")) {
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
                            "We have blocked all requests from this device "
                                "due to unusual activity. Try again later.",
                          );
                        } else
                          showAlertDialog(
                            context,
                            "Error",
                            '$error',
                          );
                        print(error);
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                      showAlertDialog(
                        context,
                        "Error",
                        'Check entries again',
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
