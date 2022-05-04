import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solar_on/Screens/domestic_custom_parameters.dart';
import 'package:solar_on/Screens/login.dart';

import 'package:solar_on/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class DomesticCustomResults extends StatefulWidget {
  const DomesticCustomResults({Key? key}) : super(key: key);
  static const String id = 'domestic_custom_results';
  @override
  _DomesticCustomResultsState createState() => _DomesticCustomResultsState();
}

class _DomesticCustomResultsState extends State<DomesticCustomResults> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late PassParametersDomestic data =
      ModalRoute.of(context)!.settings.arguments as PassParametersDomestic;

  double kWh = 0;
  double watts = 0;
  double panels = 0;
  double batteryNumber = 0;
  double backupTime = 0;
  double batteryBankCapacity = 0;
  double inverterNumber = 0;
  bool viewVisible = false;
  dynamic phoneNumber;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> snapshot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => calculate());
    getCurrentUser();
    getUserData();
  }

  Future<dynamic> getUserData() async {
    var docSnapshot = await _firestore
        .collection('users')
        .doc(loggedInUser.email.toString())
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      return data?['phone'];
    } else
      return {
        showAlertDialog(
            context, "Error", "There was an error conneting to the servers"),
        Navigator.pushReplacementNamed(context, LogIn.id),
      };
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
      print(error);
      showAlertDialog(context, "Error", '$error');
    }
  }

  void calculate() {
    for (int i = 0; i < data.item.length; i++) {
      kWh = kWh + (data.qty[i].toDouble() * data.rating[i] * data.duration[i]);
      watts = watts + data.rating[i] * data.qty[i];
    }
    setState(() {});
  }

  Text getPanelText(double watts) {
    double panelHold = data.solarYield *
        data.batteryEfficiency *
        data.cCEfficiency *
        data.invEfficiency *
        data.dirtOnPanels;
    if (watts <= 1000) {
      panels = kWh / panelHold / data.panelWattage;
      return Text(
        'Panels:\n'
        'Size: ${data.panelWattage.toStringAsFixed(0)}\n'
        'Number: ${panels.ceil().toString()} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 2400) {
      panels = kWh / panelHold / data.panelWattage;
      return Text(
        'Panels:\n'
        'Size: ${data.panelWattage}\n'
        'Number: ${panels.ceil().toString()} \n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 2400) {
      panels = kWh / panelHold / data.panelWattage;
      return Text(
        'Panels:\n'
        'Size: ${data.panelWattage}\n'
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
    if (watts < 1000) {
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
      batteryNumber = 1;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${data.batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 1000 && watts <= 2400) {
      batteryNumber = 2;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${data.batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 2400 && watts <= 5000) {
      batteryNumber = 4;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${data.batterySize.toStringAsFixed(0)} Ah\n'
        'Number: ${batteryNumber.ceil().toString()}\n',
        style: kMyTextStyleLarge(),
      );
    }
    if (watts > 5000) {
      batteryNumber = 4;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
      return Text(
        'Batteries:\n'
        'Size: ${data.batterySize.toStringAsFixed(0)} Ah\n'
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
      batteryNumber = 1;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
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
      batteryNumber = 2;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
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
      batteryNumber = 4;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
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
      batteryNumber = 4;
      double x = kWh / data.systemVoltage;
      double y = 1 + data.batteryDeratingFactor;
      batteryBankCapacity = x * y / data.invEfficiency / data.batteryDOD;
      //batteryNumber = batteryBankCapacity / batterySize;
      backupTime =
          batteryNumber * data.batterySize * data.systemVoltage / watts;
      return Text(
        '\nThis system will give you'
        ' ${backupTime.floor().toString()} hrs of backup '
        'time with everything running at the same time.\n'
        'You can add batteries in sets of 4 to increase your backup time.\n'
        'It is advised to have 8 batteries if you will run a majority of '
        'your loads using the batteries the same time.\n'
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
        body: FutureBuilder(
            future: _firestore
                .collection('transactions')
                .doc(data.mpesaResponse['CheckoutRequestID'])
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Okay',
                        style: kMyTextStyle(),
                      ),
                    )
                  ],
                  content: Text(
                    'Something went wrong. Please try again.',
                    style: kMyTextStyle(),
                  ),
                );
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Retry',
                        style: kMyTextStyleGold(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        'Refresh',
                        style: kMyTextStyleGold(),
                      ),
                    ),
                  ],
                  title: Text(
                    'There was an error with your mpesa transaction. Kindly refresh or try again.',
                    style: TextStyle(fontSize: 18),
                  ),
                  content: CircularProgressIndicator(
                    color: kGoldColor,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> onlineData =
                    snapshot.data.data() as Map<String, dynamic>;
                var resultCode =
                    onlineData['Body']['stkCallback']['ResultCode'];
                if (resultCode == 0) {
                  FirebaseFirestore.instance
                      .collection('transactions')
                      .doc(loggedInUser.email.toString())
                      .collection('response')
                      .doc(DateTime.now().toString())
                      .set(onlineData);
                  FirebaseFirestore.instance
                      .collection('transactions')
                      .doc(data.mpesaResponse['CheckoutRequestID'])
                      .delete();
                  return Column(
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
                            Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: viewVisible,
                              child: readMoreText(watts),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  viewVisible = !viewVisible;
                                });
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Color(0x11f5b700)),
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
                              onPress: () async {
                                _firestore
                                    .collection('quotations')
                                    .doc(loggedInUser.email.toString())
                                    .collection('domestic custom')
                                    .doc(DateTime.now().toString())
                                    .set(
                                  {
                                    'panel size (W)': data.panelWattage.ceil(),
                                    'panel number': panels.ceil(),
                                    'inverter size (kW)': (watts / 1000).ceil(),
                                    'battery size (Ah)':
                                        data.batterySize.ceil(),
                                    'battery number': batteryNumber.ceil(),
                                    'backup time (Hrs)': backupTime.ceil(),
                                  },
                                );
                                launch("tel:+254701088334");
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                }
                if (resultCode == 1032) {
                  return AlertDialog(
                    content: Text(
                      "You cancelled the transaction. Please try again.",
                      style: kMyTextStyle(),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Okay',
                            style: kMyTextStyleGold(),
                          ))
                    ],
                  );
                }
                if (resultCode == 2001) {
                  return AlertDialog(
                    content: Text(
                      "You gave incorrect information. Please try again.",
                      style: kMyTextStyle(),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Okay',
                            style: kMyTextStyleGold(),
                          ))
                    ],
                  );
                }
                if (resultCode == 17) {
                  return AlertDialog(
                    content: Text(
                      "We are unable to process your request because a similar transaction is currently underway. Please wait while your initial transaction is being completed.",
                      style: kMyTextStyle(),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Okay',
                            style: kMyTextStyleGold(),
                          ))
                    ],
                  );
                }
                return AlertDialog(
                  content: Text(
                    "There was an error. Please try again.",
                    style: kMyTextStyle(),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Okay',
                          style: kMyTextStyleGold(),
                        ))
                  ],
                );
              }

              return AlertDialog(
                contentPadding: EdgeInsets.all(30),
                title: Text('Something went wrong. Kindly try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Retry',
                      style: kMyTextStyleGold(),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {});
                  //   },
                  //   child: Text(
                  //     'Refresh',
                  //     style: kMyTextStyleGold(),
                  //   ),
                  // ),
                ],
                content: CircularProgressIndicator(
                  color: kGoldColor,
                ),
              );
            }),
      ),
    );
  }
}

class PassQuotation {
  PassQuotation({
    required this.panelsize,
    required this.panelnumber,
    required this.invertersize,
    required this.batterysize,
    required this.batterynumber,
    required this.backuptime,
  });
  double panelsize;
  double panelnumber;
  double invertersize;
  double batterysize;
  double batterynumber;
  double backuptime;
}
