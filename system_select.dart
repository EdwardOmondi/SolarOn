import 'package:flutter/material.dart';
import 'package:solar_on/Screens/change_details.dart';
import 'package:solar_on/Screens/domestic_easy_design.dart';
import 'package:solar_on/Screens/domestic_custom_design.dart';
import 'package:solar_on/Screens/forgot_password.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      } else {
        showAlertDialog(context, "Error", 'Error connecting to servers');

        Navigator.pushReplacementNamed(context, LogIn.id);
      }
    } catch (error) {
      showAlertDialog(context, "Error", '$error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double left = 40.0;
    double right = 40.0;
    double top = 6.0;
    double bottom = 6.0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white24,
          actions: [],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: kGoldColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '${loggedInUser.displayName}',
                        style: kMyTextStyleLarge(),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Change details',
                  style: kMyTextStyle().copyWith(color: kGoldColor),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, ChangeDetails.id);
                },
              ),
              ListTile(
                title: Text(
                  'Change password',
                  style: kMyTextStyle().copyWith(color: kGoldColor),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, ForgotPassword.id);
                },
              ),
              ListTile(
                title: Text(
                  'Log Out',
                  style: kMyTextStyle().copyWith(color: Colors.red),
                ),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushReplacementNamed(context, LogIn.id);
                },
              ),
            ],
          ),
        ),
        body: Material(
          child: Container(
            child: ListView(
              children: [
                SizedBox(
                  child: Hero(
                    tag: kLogoTag,
                    child: GoldLogoImage(
                      height: 200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Welcome ${loggedInUser.displayName}.\n'
                    'What kind of solar system would you like to design?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: ButtonMiddle(
                    text: 'Domestic (Easy)',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticEasyDesign.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: ButtonMiddle(
                    text: 'Domestic (Custom)',
                    onPress: () async {
                      Navigator.pushNamed(context, DomesticCustomDesign.id);
                    },
                  ),
                ),
/*Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: Button1(
                    text: 'Commercial (Easy)',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticCustomDesign.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: Button1(
                    text: 'Commercial (Custom)',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticCustomDesign.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: Button1(
                    text: 'Industrial (Easy)',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticCustomDesign.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: left, right: right, top: top, bottom: bottom),
                  child: Button1(
                    text: 'Industrial (Custom)',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticCustomDesign.id);
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
