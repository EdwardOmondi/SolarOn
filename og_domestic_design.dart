// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:solar_on/reusables.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solar_on/Screens/domestic_custom_results.dart';

class OgDomestic extends StatefulWidget {
  OgDomestic({Key? key}) : super(key: key);
  static const String id = 'domestic_custom';

  @override
  _OgDomesticState createState() => _OgDomesticState();
}

class _OgDomesticState extends State<OgDomestic> {
  //String dropdownValue = 'Lights';
  //final _formKey = GlobalKey<FormState>();
  final controller = ScrollController(initialScrollOffset: 0);

  int count = 0;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> qty = [];
  List<Map<String, dynamic>> rating = [];
  List<Map<String, dynamic>> duration = [];

  itemUpdate(int key, String? value) {
    int foundKey = -1;
    for (var map in items) {
      if (map.containsKey("id")) {
        if (map["id"] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      items.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> textData = {'id': key, 'value': value};
    items.add(textData);
    setState(
      () {
        prettyPrint(items);
      },
    );
  }

  qtyUpdate(int key, String value) {
    int foundKey = -1;
    for (var map in qty) {
      if (map.containsKey("id")) {
        if (map["id"] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      qty.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> qtyData = {'id': key, 'value': value};
    qty.add(qtyData);
    setState(
      () {
        prettyPrint(qty);
      },
    );
  }

  durationUpdate(int key, String value) {
    int foundKey = -1;
    for (var map in duration) {
      if (map.containsKey("id")) {
        if (map["id"] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      duration.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> durationData = {'id': key, 'value': value};
    duration.add(durationData);
    setState(
      () {
        prettyPrint(duration);
      },
    );
  }

  ratingUpdate(int key, String value) {
    int foundKey = -1;
    for (var map in rating) {
      if (map.containsKey("id")) {
        if (map["id"] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      rating.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> ratingData = {'id': key, 'value': value};
    rating.add(ratingData);
    setState(
      () {
        prettyPrint(rating);
      },
    );
  }

  prettyPrint(jsonObject) {
    var encoder = JsonEncoder.withIndent('    ');
    return encoder.convert(jsonObject);
  }

  row(int key) {
    //String dropdownValue = 'Lights';
    int number = key + 1;
    return Form(
      key: UniqueKey(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              '$number.',
              style: kMyTextStyle(),
            ),
            /*DropdownButton<String>(
              hint: Text('Items'),
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: kGoldColor,
              ),
              underline: Container(
                height: 1,
                color: kGoldColor,
              ),
              onChanged: (String? newValue) {
                itemUpdate(key, newValue);
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Lights',
                'TV',
                'Sound System',
                'Fridge',
                'Router',
                'Microwave',
                'Kettle',
                'Blender',
                'Toaster',
                'Sandwich maker'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),*/
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                //controller: item,
                style: kMyTextStyle(),
                decoration: kMyTextDecoration('Item', 'e.g. Lights'),
                //keyboardType: TextInputType.emailAddress,
                cursorColor: kGoldColor,
                validator: (text) {
                  if (text != null) {
                    if (text.isNotEmpty && text.length >= 2) {
                      return null;
                    } else if (text.length < 2 && text.isNotEmpty) {
                      return 'Too short';
                    } else if (text.contains(' @#\$%^&*()_+!~`=-\'\\;:.,')) {
                      return 'Only Letters';
                    } else {
                      return '*Required';
                    }
                  }
                },
                onChanged: (value) {
                  itemUpdate(key, value);
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                //controller: quantity,
                style: kMyTextStyle(),
                decoration: kMyTextDecoration('Qty', 'e.g. 2'),
                //keyboardType: TextInputType.emailAddress,
                cursorColor: kGoldColor,
                validator: (text) {
                  if (text != null) {
                    if (text.isEmpty) {
                      return 'Required';
                    } else if (int.parse(text) <= 0) {
                      return 'No > 0';
                    } else if (text.contains(' @#\$%^&*()_+!~`=-\'\\;:.,')) {
                      return 'Only Numbers';
                    } /*else if (int.parse(text) == null) {
                      return 'Enter digit(s)';
                    }*/
                    else {
                      return null;
                    }
                  }
                },
                onChanged: (value) {
                  qtyUpdate(key, value);
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                //controller: rating,
                style: kMyTextStyle(),
                decoration: kMyTextDecoration('Rating', 'e.g.100'),
                //keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text != null) {
                    if (text.isEmpty) {
                      return 'Required';
                    } else if (int.parse(text) <= 0) {
                      return 'No. > 0';
                    } else if (text.contains(' @#\$%^&*()_+!~`=-\'\\;:.,')) {
                      return 'Only Numbers';
                    } else {
                      return null;
                    }
                  }
                },
                cursorColor: kGoldColor,
                onChanged: (value) {
                  ratingUpdate(key, value);
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                // controller: duration,
                style: kMyTextStyle(),
                decoration:
                    kMyTextDecoration('Duration', 'e.g. 0.5 (Decimals only)'),
                //keyboardType: TextInputType.emailAddress,
                cursorColor: kGoldColor,
                validator: (text) {
                  if (text != null) {
                    if (text.isEmpty) {
                      return 'Required';
                    } else if (double.parse(text) <= 0) {
                      return 'No. > 0';
                    } else if (double.parse(text) < 0 && !text.contains('0.')) {
                      return 'Must have \"0.\"';
                    } else if (text.contains(' @#\$%^&*()_+!~`=-\'\\;:,')) {
                      return 'Only Decimals';
                    } else {
                      return null;
                    }
                  }
                },
                onChanged: (value) {
                  durationUpdate(key, value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.jumpTo(controller.position.maxScrollExtent);
      } //write or call your logic}
      //code will run when widget rendering complete
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Column(
          children: [
            Container(
              child: SvgPicture.asset(kLogoGold),
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ' Please key in the item you want to put on solar, '
                'their power rating (in watts) and the duration '
                'they run (in hours)',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView.builder(
                controller: controller,
                shrinkWrap: true,
                itemCount: count,
                itemBuilder: (context, index) {
                  return row(index);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button2(
                  text: '+ Item',
                  onPress: () {
                    if (count > 1) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        controller.jumpTo(controller.position.maxScrollExtent);
                      });
                    }
                    setState(() {
                      count++;
                    });
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                Button2(
                  text: '- Item',
                  onPress: () {
                    if (count > 0) {
                      setState(() {
                        count--;
                      });
                    }
                  },
                ),
              ],
            ),
            Button1(
              text: 'Submit',
              onPress: () {
                if (count > 0 &&
                    items.length > 0 &&
                    qty.length > 0 &&
                    rating.length > 0 &&
                    duration.length > 0) {
                  Navigator.pushNamed(
                    context,
                    DomesticCustomResults.id,
                    arguments: PassItemDataDomestic(
                        item: items,
                        qty: qty,
                        rating: rating,
                        duration: duration),
                  );
                } else
                  showAlertDialog(
                    context,
                    "Error",
                    'Add Items',
                  );

                /*if (_formKey.currentState!.validate() &&
                    items.length != null) {
                  Navigator.pushNamed(
                    context,
                    DomesticResults.id,
                    arguments: PassItemData(
                        item: items,
                        qty: qty,
                        rating: rating,
                        duration: duration),
                  );
                } else
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Add Items')));*/
              },
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class PassItemDataDomestic {
  PassItemDataDomestic(
      {required this.item,
      required this.qty,
      required this.rating,
      required this.duration});

  List item;
  List qty;
  List rating;
  List duration;
}
