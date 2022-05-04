import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_on/Screens/domestic_easy_design.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/Screens/quotationsDomesticEasy.dart';
import 'package:solar_on/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DomesticEasyResults extends StatefulWidget {
  const DomesticEasyResults({Key? key}) : super(key: key);
  static const String id = 'commercial_results';
  @override
  _DomesticEasyResultsState createState() => _DomesticEasyResultsState();
}

class _DomesticEasyResultsState extends State<DomesticEasyResults> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late PassItemDataDomesticEasy results =
      ModalRoute.of(context)!.settings.arguments as PassItemDataDomesticEasy;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double kWh = 0;
  double watts = 0;
  double panels = 0;
  double minimumSolarYield = 4.196;
  double batteryEfficiency = 0.85;
  double chargeControllerEfficiency = .96;
  double inverterEfficiency = .96;
  double dirtBuildupOnPanels = .96;
  double panelWattage = 400;
  double batterySize = 200;
  double batteryDeratingFactor = .10;
  double batteryDOD = 0.5;
  double batteryNumber = 0;
  double backupTime = 0;
  double systemVoltage = 0;
  double batteryBankCapacity = 0;
  bool viewVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => calculate());
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

  void calculate() {
    for (int i = 0; i < results.item.length; i++) {
      kWh = kWh +
          (results.qty[i].toDouble() * results.rating[i] * results.duration[i]);
      watts = watts + results.rating[i] * results.qty[i];
    }
    setState(() {});
  }

  Text getPanelText(double watts) {
    double panelHold = minimumSolarYield *
        batteryEfficiency *
        chargeControllerEfficiency *
        inverterEfficiency *
        dirtBuildupOnPanels;
    if (watts <= 1000) {
      panels = kWh / panelHold / 300;
      return Text(
        'Panels:\n'
        'Size: 300 Watts\n'
        'Number: ${panels.ceil().toString()} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 2400) {
      panels = kWh / panelHold / 400;
      return Text(
        'Panels:\n'
        'Size: 400 Watts\n'
        'Number: ${panels.ceil().toString()} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 2400) {
      panels = kWh / panelHold / 450;
      return Text(
        'Panels:\n'
        'Size: 450 Watts\n'
        'Number: ${panels.ceil().toString()} \n',
        style: kMyTextStyleLarge(),
      );
    }

    return Text(
      'Check your input in the previous page',
      style: kMyTextStyleLarge(),
    );
  }

  Text getInverterText(double watts) {
    if (watts <= 1000) {
      return Text(
        'Inverter:\n'
        'Size: ${(watts / 1000).toStringAsFixed(2)} kW '
        'hybrid inverter\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 5000) {
      return Text(
        'Inverter:\n'
        'Size: ${(watts / 1000).ceil().toString()} kW '
        'hybrid inverter\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 5000) {
      return Text(
        'Inverter:\n'
        'Size: 5 kW hybrid inverter.\n'
        'NOTE:\n'
        'You will not be able to switch on all the devices at the same time.\n'
        'Should you want to do this, get a ${(watts / 1000).toStringAsFixed(2)} kW inverter.\n',
        style: kMyTextStyleLarge(),
      );
    }
    return Text(
      'Check your input in the previous page',
      style: kMyTextStyleLarge(),
    );
  }

  Text getBatteryText(double watts) {
    if (watts <= 1000) {
      systemVoltage = 12;
      batteryNumber = 1;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 2400) {
      systemVoltage = 24;
      batteryNumber = 2;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 2400 && watts <= 5000) {
      systemVoltage = 48;
      batteryNumber = 4;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 5000) {
      systemVoltage = 48;
      batteryNumber = 4;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }

    return Text(
      'Check your input in the previous page',
      style: kMyTextStyleLarge(),
    );
  }

  Text readMoreText(double watts) {
    if (watts <= 1000) {
      systemVoltage = 12;
      batteryNumber = 1;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        '\nThis system will give you'
        ' ${backupTime.floor().toString()} hrs of backup '
        'time with everything running at the same time.\n'
        '\nYou can add a battery to increase your backup time.\n'
        '\nTotal energy used per day is ${(kWh / 1000).toStringAsFixed(2)} '
        'kilowatthours (kWh) a.k.a. units\n '
        '\nNote: This is the minimum requirement. Anything '
        'lower would not be advised.\n ',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 2400) {
      systemVoltage = 24;
      batteryNumber = 2;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        '\nThis system will give you'
        ' ${backupTime.floor().toString()} hrs of backup '
        'time with everything running at the same time.\n'
        'You can add batteries in sets of 2 to increase your backup time.\n'
        '\nTotal energy used per day is ${(kWh / 1000).toStringAsFixed(2)} '
        'kilowatthours (kWh) a.k.a. units\n '
        '\nNote: This is the minimum requirement. Anything '
        'lower would not be advised.\n ',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 2400 && watts <= 5000) {
      systemVoltage = 48;
      batteryNumber = 4;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        '\nThis system will give you'
        ' ${backupTime.floor().toString()} hrs of backup '
        'time with everything running at the same time.\n'
        'You can add batteries in sets of four.\n'
        '\nTotal energy used per day is ${(kWh / 1000).toStringAsFixed(2)} '
        'kilowatthours (kWh) a.k.a. units\n '
        '\nNote: This is the minimum requirement. Anything '
        'lower would not be advised.\n ',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 5000) {
      systemVoltage = 48;
      batteryNumber = 4;
      double x = kWh / systemVoltage;
      double y = 1 + batteryDeratingFactor;
      batteryBankCapacity = x * y / inverterEfficiency / batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime = batteryNumber * batterySize * systemVoltage / watts;
      return Text(
        '\nThis system will give you'
        ' ${backupTime.floor().toString()} hrs of backup '
        'time with everything running at the same time.\n'
        'You can add batteries in sets of 4 to increase your backup time.\n'
        'It is advised to have 8 batteries if you will run a majority of '
        'your loads using the batteries all at the same time.\n'
        '\nTotal energy used per day is ${(kWh / 1000).toStringAsFixed(2)} '
        'kilowatthours (kWh) a.k.a. units\n '
        '\nNote: This is the minimum requirement. Anything '
        'lower would not be advised.\n ',
        style: kMyTextStyleLarge(),
      );
    }

    return Text(
      'Check your input in the previous page',
      style: kMyTextStyleLarge(),
    );
  }

  @override
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
                      child: getPanelText(watts) //Panels
                      ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: getInverterText(watts) //Inverter
                      ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: getBatteryText(watts) //Backup time
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
                      child: readMoreText(watts),
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
                  )
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
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Button2(
                    text: 'Quotation',
                    onPress: () {
                      _firestore
                          .collection('quotations')
                          .doc(loggedInUser.email.toString())
                          .collection('domestic easy')
                          .doc(DateTime.now().toString())
                          .set(
                        {
                          'panel size (W)': panelWattage.ceil(),
                          'panel number': panels.ceil(),
                          'inverter size (kW)': (watts / 1000).ceil(),
                          'battery size (Ah)': batterySize.ceil(),
                          'battery number': batteryNumber.ceil(),
                          'backup time (Hrs)': backupTime.ceil(),
                        },
                      );
                      // launch("tel:+254701088334");
                      Navigator.pushNamed(
                        context,
                        QuotationDomesticEasy.id,
                        arguments: PassResultsDomesticEasy(
                          panelWattage: panelWattage.ceil(),
                          panelNumber: panels.ceil(),
                          inverterSize: (watts / 1000).ceil(),
                          batterySize: batterySize.ceil(),
                          watts: watts,
                          batteryNumber: batteryNumber.ceil(),
                        ),
                      );
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

class PassResultsDomesticEasy {
  PassResultsDomesticEasy({
    required this.panelWattage,
    required this.panelNumber,
    required this.inverterSize,
    required this.batterySize,
    required this.batteryNumber,
    required this.watts,
  });
  int panelWattage;
  int panelNumber;
  int inverterSize;
  int batterySize;
  int batteryNumber;
  double watts;
}
