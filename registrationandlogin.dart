import 'package:flutter/material.dart';
import 'package:solar_on/Screens/TestScreen.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/Screens/signup.dart';
import 'package:solar_on/reusables.dart';

class RegistrationAndLogIn extends StatelessWidget {
  const RegistrationAndLogIn({Key? key}) : super(key: key);
  static const String id = 'registration_and_login';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () {
              // Navigator.pushNamed(context, RegistrationAndLogIn.id);
              Navigator.pushNamed(context, TestPage.id);
            },
            child: Hero(
              tag: kLogoTag,
              child: GoldLogoImage(
                height: MediaQuery.of(context).size.height * 0.35,
              ),
            ),
          ),
          Text(
            'SolarOn',
            style: TextStyle(
              fontFamily: 'Sifonn',
              color: kGoldColor,
              fontSize: 60,
            ),
          ),
          Text(
            'Solar system sizing and quotations',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Button1(
            text: ' Sign Up ',
            onPress: () {
              Navigator.pushNamed(context, SignUp.id);
            },
          ),
          SizedBox(
            height: 30,
          ),
          Button1(
            text: ' Log In ',
            onPress: () {
              Navigator.pushNamed(context, LogIn.id);
            },
          ),
        ],
      ),
    );
  }
}
