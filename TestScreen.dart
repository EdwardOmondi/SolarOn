import 'package:flutter/material.dart';

import '../reusables.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  static const String id = 'test_page';

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Easter Egg",
              style: kMyTextStyleGold().copyWith(fontSize: 50),
            ),
          ),
          Icon(
            Icons.icecream_outlined,
            color: kGoldColor,
            size: 50,
          ),
        ],
      ),
    );
  }
}
