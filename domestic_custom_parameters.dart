import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solar_on/Screens/domestic_custom_results.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/mpesa.dart';
import 'package:solar_on/reusables.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'domestic_custom_design.dart';

class DomesticCustomParameters extends StatefulWidget {
  const DomesticCustomParameters({Key? key}) : super(key: key);
  static const String id = 'domestic_custom_parameters';
  @override
  _DomesticCustomParametersState createState() =>
      _DomesticCustomParametersState();
}

class _DomesticCustomParametersState extends State<DomesticCustomParameters> {
  bool showSpinner = false;
  late PassItemDataDomesticCustom itemData =
      ModalRoute.of(context)!.settings.arguments as PassItemDataDomesticCustom;
  double solarYield = 4.196;
  double batteryEfficiency = 0.8;
  double cCEfficiency = 0.96;
  double invEfficiency = 0.96;
  double dirtOnPanels = 0.96;
  double panelWattage = 400;
  double batterySize = 200;
  double batteryDeratingFactor = 0.10;
  double batteryDOD = 0.5;
  double systemVoltage = 24;
  late User loggedInUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var mpesaResponse;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: logoAndPhone(context),
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 5),
                    child: Text(
                      'Please give the system parameters:',
                      style: kMyTextStyle(),
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Minimum solar yield (kWh/kWp/day)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                solarYield.toStringAsFixed(3),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: solarYield,
                                  min: 3.5,
                                  max: 5.0,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        solarYield = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //solar yield
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Battery Efficiency (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                batteryEfficiency.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: batteryEfficiency,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        batteryEfficiency = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //battery eff
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Charge Controller efficiency (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                cCEfficiency.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: cCEfficiency,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        cCEfficiency = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //cc eff
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Inverter Efficiency (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                invEfficiency.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: invEfficiency,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        invEfficiency = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //inv eff
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Dirt Buildup on panels (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                dirtOnPanels.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: dirtOnPanels,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        dirtOnPanels = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //dirt
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Panel Wattage (W)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                panelWattage.toStringAsFixed(0),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: panelWattage,
                                  min: 200,
                                  max: 500,
                                  divisions: 60,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        panelWattage = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //panel W
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Battery Size (Ah)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                batterySize.toStringAsFixed(0),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: batterySize,
                                  min: 50,
                                  max: 500,
                                  divisions: 90,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        batterySize = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //batt Ah
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Battery Derating Factor (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                batteryDeratingFactor.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: batteryDeratingFactor,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        batteryDeratingFactor = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //batt derating
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Battery Depth of discharge (0-1)',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                batteryDOD.toStringAsFixed(2),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: batteryDOD,
                                  min: 0.01,
                                  max: 1,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        batteryDOD = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), //batt DOD
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'System Voltage',
                                style: kMyTextStyle(),
                              ),
                              Text(
                                systemVoltage.toStringAsFixed(0),
                                style: kMyTextStyle(),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color(0xfff5b700),
                                  inactiveTrackColor: Color(0x99f5b700),
                                  thumbColor: Color(0xfff5b700),
                                  overlayColor: Color(0x99f5b700),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  divisions: 4,
                                  value: systemVoltage,
                                  min: 0.01,
                                  max: 48,
                                  onChanged: (double val) {
                                    setState(
                                      () {
                                        systemVoltage = val;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button2(
                        text: 'Change items',
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
                      Button2(
                        text: ' Design ',
                        onPress: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Loading...',
                                style: TextStyle(
                                  color: kGoldColor,
                                ),
                              ),
                              backgroundColor: kScaffoldWhite,
                              duration: Duration(
                                seconds: 16,
                              ),
                            ),
                          );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(loggedInUser.email.toString())
                              .get()
                              .then((DocumentSnapshot documentSnapshot) async {
                            if (documentSnapshot.exists) {
                              await FirebaseFirestore.instance
                                  .collection('designs')
                                  .doc(loggedInUser.email.toString())
                                  .collection('domestic custom')
                                  .doc(DateTime.now().toString())
                                  .set({
                                'batteryEfficiency': batteryEfficiency,
                                'solarYield': solarYield,
                                'batteryDeratingFactor': batteryDeratingFactor,
                                'batteryDOD': batteryDOD,
                                'batterySize': batterySize,
                                'cCEfficiency': cCEfficiency,
                                'dirtOnPanels': dirtOnPanels,
                                'invEfficiency': invEfficiency,
                                'panelWattage': panelWattage.ceilToDouble(),
                                'systemVoltage': systemVoltage,
                                'item': itemData.item,
                                'qty': itemData.qty,
                                'rating': itemData.rating,
                                'duration': itemData.duration
                              });

                              Map<String, dynamic> pulledData = documentSnapshot
                                  .data() as Map<String, dynamic>;
                              var phoneNumber =
                                  pulledData["phone"].substring(1);

                              await Mpesa()
                                  .mSTKRequest(
                                      mAmount: 1,
                                      mPhoneNumber: phoneNumber,
                                      mAccountReference: 'SolarOn',
                                      mTransactionDesc: 'Custom Design Charge',
                                      loggedInUser:
                                          loggedInUser.email.toString())
                                  .then((value) {
                                mpesaResponse = value;
                              });
                              // int count = 0;
                              // FirebaseFirestore.instance
                              //     .collection('transactions')
                              //     .snapshots()
                              //     .listen((event) {
                              //   print('\n${DateTime.now().toString()}: '
                              //       'event has occured');
                              //   event.docs.forEach((element) {
                              //     Map<String, dynamic> data = element.data();
                              //     // if (data['Body']['stkCallback']
                              //     //         ['CheckoutRequestID'] ==
                              //     //     mpesaResponse['CheckoutRequestID']) {
                              //     //   print('Yes');
                              //     // }
                              //
                              //     print('\n${DateTime.now().toString()} \n'
                              //         '${data['Body']}'
                              //         '\n------\n'
                              //         '$count '
                              //         '\n------\n');
                              //     count++;
                              //   });
                              //
                              //   print('end');
                              // });
                              // count = 0;
                              // print('reset');

                              await Future.delayed(
                                Duration(seconds: 15),
                                () {
                                  FirebaseFirestore.instance
                                      .collection('transactions')
                                      .doc(mpesaResponse['CheckoutRequestID'])
                                      .get()
                                      .then(
                                    (DocumentSnapshot documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        print(
                                            'Document data: ${documentSnapshot.data()}');
                                      } else {
                                        print(
                                            'mpesaResponse does not exist on the database');
                                      }
                                    },
                                  );
                                },
                              );
                              await Navigator.pushNamed(
                                context,
                                DomesticCustomResults.id,
                                arguments: PassParametersDomestic(
                                    batteryEfficiency: batteryEfficiency,
                                    solarYield: solarYield,
                                    batteryDeratingFactor:
                                        batteryDeratingFactor,
                                    batteryDOD: batteryDOD,
                                    batterySize: batterySize,
                                    cCEfficiency: cCEfficiency,
                                    dirtOnPanels: dirtOnPanels,
                                    invEfficiency: invEfficiency,
                                    panelWattage: panelWattage.ceilToDouble(),
                                    systemVoltage: systemVoltage,
                                    item: itemData.item,
                                    qty: itemData.qty,
                                    rating: itemData.rating,
                                    duration: itemData.duration,
                                    mpesaResponse: mpesaResponse),
                              );
                            } else {
                              print('Document does not exist on the database');
                            }
                          });
                          setState(() {
                            showSpinner = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

/*class Parameters extends StatefulWidget {
  Parameters({
    required this.text,
    required this.value,
    required this.min,
    required this.max,
    required this.decimals,
  });

  final String text;
  late double value;
  final double min;
  final double max;
  final int decimals;

  @override
  _ParametersState createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  late double _value;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: Column(
        children: [
          Text(
            widget.text,
            style: kMyTextStyle(),
          ),
          Text(
            widget.value.toStringAsFixed(widget.decimals),
            style: kMyTextStyle(),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xfff5b700),
              inactiveTrackColor: Color(0x99f5b700),
              thumbColor: Color(0xfff5b700),
              overlayColor: Color(0x99f5b700),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 16,
              ),
            ),
            child: Slider(
              value: _value,
              min: widget.min,
              max: widget.max,
              onChanged: (double val) {
                setState(
                  () {
                    _value = val;
                    widget.value = val;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/

class PassParametersDomestic {
  PassParametersDomestic({
    required this.batteryEfficiency,
    required this.solarYield,
    required this.batteryDeratingFactor,
    required this.batteryDOD,
    required this.batterySize,
    required this.cCEfficiency,
    required this.dirtOnPanels,
    required this.invEfficiency,
    required this.panelWattage,
    required this.item,
    required this.qty,
    required this.rating,
    required this.duration,
    required this.systemVoltage,
    required this.mpesaResponse,
  });
  double solarYield;
  double batteryEfficiency;
  double cCEfficiency;
  double invEfficiency;
  double dirtOnPanels;
  double panelWattage;
  double batterySize;
  double batteryDeratingFactor;
  double batteryDOD;
  double systemVoltage;
  List item;
  List qty;
  List rating;
  List duration;
  Map<String, String> mpesaResponse;
}
// FirebaseFirestore.instance
//     .collection('transactions')
//     .doc(loggedInUser.email.toString())
//     .collection('response')
//     .doc(DateTime.now().toString())
//     .set(data);

// event.docs.forEach((element) {
//   Map<String, dynamic> data = element.data();
//   List responses = [];
//   responses.add(data);
//   print('\n${DateTime.now().toString()} \n'
//       '$data \n ------\n');
// });
