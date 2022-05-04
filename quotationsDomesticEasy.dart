import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'domestic_easy_design.dart';
import 'domestic_easy_results.dart';
import 'login.dart';

class QuotationDomesticEasy extends StatefulWidget {
  static const String id = 'quotations';

  @override
  _QuotationDomesticEasyState createState() => _QuotationDomesticEasyState();
}

class _QuotationDomesticEasyState extends State<QuotationDomesticEasy> {
  late PassResultsDomesticEasy results =
      ModalRoute.of(context)!.settings.arguments as PassResultsDomesticEasy;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  double vat = 1.16;
  double pMargin = 1.10;
  double price = 1000000.00;
  late double panelPrice;
  late double invPrice;
  late double battPrice;
  bool viewVisible = false;

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
        showAlertDialog(
          context,
          "Error",
          'Error connecting to servers',
        );

        Navigator.pushReplacementNamed(context, LogIn.id);
      }
    } catch (error) {
      print(error);
      showAlertDialog(
        context,
        "Error",
        '$error',
      );
    }
  }

  Text getPanelPrice() {
    var formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
    panelPrice =
        results.panelWattage * results.panelNumber * 51 * vat * pMargin;
    return Text(
      'Panels:\n'
      'Kshs. ${formatCurrency.format(panelPrice)} \n',
      style: kMyTextStyleLarge(),
    );
  }

  Text getInverterPrice(double watts) {
    var formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
    if (watts <= 1000) {
      invPrice = watts * 20 * vat * pMargin;
      return Text(
        'Inverter:\n'
        'Kshs. ${formatCurrency.format(invPrice)} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 5000) {
      invPrice = watts * 25 * vat * pMargin;
      return Text(
        'Inverter:\n'
        'Kshs. ${formatCurrency.format(invPrice)} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 5000) {
      invPrice = watts * 30 * vat * pMargin;
      return Text(
        'Inverter:\n'
        'Kshs. ${formatCurrency.format(invPrice)} \n',
        style: kMyTextStyleLarge(),
      );
    }
    return Text(
      'Check your input in the design page',
      style: kMyTextStyleLarge(),
    );
  }

  Text getBatteryPrice() {
    var formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
    battPrice =
        results.batterySize * results.batteryNumber * 1.5 * 110 * vat * pMargin;

    return Text(
      'Batteries:\n'
      'Kshs. ${formatCurrency.format(battPrice)} \n',
      style: kMyTextStyleLarge(),
    );
  }

  Text readMoreText() {
    return Text(
      'This is a quotation for guidance and not the final price.',
      style: kMyTextStyleLarge(),
    );
  }

  Text totalPrice() {
    var formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
    double total = battPrice + invPrice + panelPrice;
    return Text(
      'Total:\n'
      'Kshs. ${formatCurrency.format(total)} \n',
      style: kMyTextStyleLarge(),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: logoAndPhone(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      '${loggedInUser.email}',
                      style: kMyTextStyleGold(),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: getPanelPrice() //Panels
                      ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: getInverterPrice(results.watts) //Inverter
                      ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: getBatteryPrice() //Backup time
                      ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: totalPrice() //Backup time
                      ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: viewVisible,
                      child: readMoreText(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        viewVisible = !viewVisible;
                      });
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all<Color>(Color(0x11f5b700)),
                    ),
                    child: viewVisible
                        ? Text(
                            'Read less',
                            style: kMyTextStyleGold(),
                          )
                        : Text(
                            'Read more',
                            style: kMyTextStyleGold(),
                          ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Button2(
                    text: 'Re-design',
                    onPress: () {
                      Navigator.pushNamed(context, DomesticEasyDesign.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Button2(
                    text: 'Order',
                    onPress: () {
                      launch("tel:+254701088334");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
