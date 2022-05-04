import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solar_on/Screens/domestic_easy_results.dart';
import 'package:solar_on/Screens/login.dart';
import 'package:solar_on/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DomesticEasyDesign extends StatefulWidget {
  const DomesticEasyDesign({Key? key}) : super(key: key);
  static const String id = 'commercial_design';

  @override
  _DomesticEasyDesignState createState() => _DomesticEasyDesignState();
}

class _DomesticEasyDesignState extends State<DomesticEasyDesign> {
  List<CartItem> cart = [];
  List<String> items = [];
  List<int> qty = [];
  List<double> rating = [];
  List<double> duration = [];
  bool showSpinner = false;
  final controller = ScrollController(initialScrollOffset: 0);
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void refresh() {
    setState(() {});
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' Please key in the items you want to put on solar, '
                  'their power rating (in watts) and the duration '
                  'they run (in hours): ${cart.length}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    key: UniqueKey(),
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: (MediaQuery.of(context).size.height) * .01,
                            ),
                            child: Text(
                              '${(index + 1)}. ',
                              style: kMyTextStyle(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: (MediaQuery.of(context).size.height) * .01,
                              right: (MediaQuery.of(context).size.height) * .01,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  30,
                                ),
                              ),
                              border: Border.all(
                                color: kGoldColor,
                              ),
                            ),
                            child: CartWidget(
                                cart: cart, index: index, callback: refresh),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button2(
                    text: 'Add Item',
                    onPress: () {
                      WidgetsBinding.instance!.addPostFrameCallback(
                        (_) {
                          controller
                              .jumpTo(controller.position.maxScrollExtent);
                        },
                      );

                      cart.add(CartItem(
                        productType: " Commercial",
                        item: "Lights",
                        quantity: 0,
                        duration: 0,
                        rating: 0,
                      ));
                      setState(() {});
                    },
                  ),
                  Button2(
                    text: 'Submit',
                    onPress: () {
                      setState(() {
                        showSpinner = true;
                      });

                      items.clear();
                      qty.clear();
                      rating.clear();
                      duration.clear();

                      for (int i = 0; i < cart.length; i++) {
                        items.add(cart[i].item);
                        qty.add(cart[i].quantity);
                        rating.add(cart[i].rating);
                        duration.add(cart[i].duration);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                      if (items.length > 0 &&
                          qty.length > 0 &&
                          rating.length > 0 &&
                          duration.length > 0) {
                        if (qty.contains(0) ||
                            rating.contains(0) ||
                            duration.contains(0)) {
                          showAlertDialog(context, 'Error',
                              'Cannot have a \"0\" in the items');
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          _firestore
                              .collection('designs')
                              .doc(loggedInUser.email.toString())
                              .collection('domestic easy')
                              .doc(DateTime.now().toString())
                              .set(
                            {
                              'item': items,
                              'qty': qty,
                              'rating': rating,
                              'duration': duration
                            },
                          );
                          Navigator.pushNamed(
                            context,
                            DomesticEasyResults.id,
                            arguments: PassItemDataDomesticEasy(
                                item: items,
                                qty: qty,
                                rating: rating,
                                duration: duration),
                          );
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } else
                        showAlertDialog(context, "Error", "Add items first");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CartWidget extends StatefulWidget {
  final List<CartItem> cart;
  final int index;
  final VoidCallback callback;

  CartWidget({required this.cart, required this.index, required this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Item(cartItem: widget.cart[widget.index]),
            SizedBox(
              width: 5,
            ),
            ItemQuantity(cartItem: widget.cart[widget.index]),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemRating(cartItem: widget.cart[widget.index]),
            SizedBox(
              width: 5,
            ),
            ItemDuration(cartItem: widget.cart[widget.index]),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              widget.cart.removeAt(widget.index);
              widget.callback();
            });
          },
        )
      ],
    );
  }
}

class Item extends StatefulWidget {
  final CartItem cartItem;

  Item({required this.cartItem});
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.item;
  }

  @override
  void didUpdateWidget(Item oldWidget) {
    if (oldWidget.cartItem.item != widget.cartItem.item) {
      _value = widget.cartItem.item;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Text(
            'Items',
            style: kMyTextStyle(),
          ),
          DropdownButton<String>(
              value: _value,
              items: [
                DropdownMenuItem(child: Text("Lights"), value: "Lights"),
                DropdownMenuItem(child: Text("Tv"), value: "Tv"),
                DropdownMenuItem(child: Text("Fridge"), value: "Fridge"),
                DropdownMenuItem(child: Text("Laptop"), value: "Laptop"),
                DropdownMenuItem(child: Text("Microwave"), value: "Microwave"),
                DropdownMenuItem(
                    child: Text("WiFi Router"), value: "WiFi Router"),
                DropdownMenuItem(
                    child: Text("Small Pump"), value: "Small Pump"),
                DropdownMenuItem(child: Text("Other"), value: "Other"),
              ],
              onChanged: (value) {
                setState(() {
                  _value = value!;
                  widget.cartItem.item = value;
                });
              }),
        ],
      ),
    );
  }
}

class ItemQuantity extends StatefulWidget {
  final CartItem cartItem;

  ItemQuantity({required this.cartItem});
  @override
  _ItemQuantityState createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.quantity;
  }

  @override
  void didUpdateWidget(ItemQuantity oldWidget) {
    if (oldWidget.cartItem.quantity != widget.cartItem.quantity) {
      _value = widget.cartItem.quantity;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Text(
            'Quantity',
            style: kMyTextStyle(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _value = _value + 1;
                    widget.cartItem.quantity = widget.cartItem.quantity + 1;
                  });
                },
                icon: Icon(Icons.add),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.cartItem.quantity.toString(),
                style: kMyTextStyleGold(),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _value = _value - 1;
                    widget.cartItem.quantity = widget.cartItem.quantity - 1;
                  });
                },
                icon: Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemRating extends StatefulWidget {
  final CartItem cartItem;

  ItemRating({required this.cartItem});
  @override
  _ItemRatingState createState() => _ItemRatingState();
}

class _ItemRatingState extends State<ItemRating> {
  // ignore: unused_field
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.duration;
  }

  @override
  void didUpdateWidget(ItemRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItem.rating != widget.cartItem.rating) {
      _value = widget.cartItem.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Power",
                style: kMyTextStyle(),
              ),
              InfoButton(
                text:
                    'The rated power. Usually found behind or underneath the electrical appliance. The largest value with a \"W\".',
                onPress: () {
                  showAlertDialog(
                      context,
                      "Power",
                      'The rated power. Usually found'
                          ' behind or underneath the electrical appliance. The'
                          ' largest value with a \"W\".');
                },
              )
            ],
          ),
          Text(
            '${widget.cartItem.rating.toStringAsFixed(0)} watts',
            style: kMyTextStyleGold(),
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
              value: widget.cartItem.rating,
              min: 0,
              max: 1000,
              divisions: 200,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                  widget.cartItem.rating = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDuration extends StatefulWidget {
  final CartItem cartItem;

  ItemDuration({required this.cartItem});
  @override
  _ItemDurationState createState() => _ItemDurationState();
}

class _ItemDurationState extends State<ItemDuration> {
  //late double _value;

  @override
  void initState() {
    super.initState();
    //_value = widget.cartItem.duration;
  }

  @override
  void didUpdateWidget(ItemDuration oldWidget) {
    if (oldWidget.cartItem.duration != widget.cartItem.duration) {
      // _value = widget.cartItem.duration;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Time",
                style: kMyTextStyle(),
              ),
              InfoButton(
                text:
                    'The running period. The time in hours the electrical device is operational',
                onPress: () {
                  showAlertDialog(
                    context,
                    "Time",
                    'The running period. The amount of time the device runs per day.',
                  );
                },
              ),
            ],
          ),
          Text(
            '${widget.cartItem.duration.toStringAsFixed(1)} hours',
            style: kMyTextStyleGold(),
          ),
          SizedBox(
            width: 5,
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
              value: widget.cartItem.duration,
              min: 0,
              max: 24,
              onChanged: (double value) {
                setState(() {
                  //_value = value;
                  widget.cartItem.duration = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  String productType;
  String item;
  int quantity;
  double rating;
  double duration;

  CartItem({
    required this.productType,
    required this.item,
    required this.quantity,
    required this.rating,
    required this.duration,
  });
}

class PassItemDataDomesticEasy {
  PassItemDataDomesticEasy(
      {required this.item,
      required this.qty,
      required this.rating,
      required this.duration});

  List item;
  List qty;
  List rating;
  List duration;
}
