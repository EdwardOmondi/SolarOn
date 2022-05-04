import 'package:flutter/material.dart';
import 'package:solar_on/Screens/registrationandlogin.dart';
import 'package:solar_on/reusables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);
  static const String id = 'welcome_page';

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    _navigateToHome();
    super.initState();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, RegistrationAndLogIn.id);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kGoldColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            kLogoWhite,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ],
      ),
    );
  }
}
