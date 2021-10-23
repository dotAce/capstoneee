import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/consumer_map.dart';
import 'package:http/http.dart' as http;
import '../model.dart';

import 'package:maps_toolkit/maps_toolkit.dart';

class Order extends StatefulWidget {
  _OrderState createState() =>
      _OrderState(orderID, consumer_username, quantity, total);

  // ignore: non_constant_identifier_names
  String orderID;
  String consumer_username;
  String quantity;
  int total;
  // ignore: non_constant_identifier_names
  Order({this.orderID, this.consumer_username, this.quantity, this.total});
}

class _OrderState extends State<Order> {
  String orderID;
  String quantity;
  int total;
  String consumer_username;
  _OrderState(this.orderID, this.consumer_username, this.quantity, this.total);

  bool loading = true;
  String order_ID;
  String productName;
  String productPrice;
  String orderstat;
  String path;
  Timer timer;
  double sellerLat;
  double sellerLong;
  double consumerLat;
  double consumerLong;
  Timer timerss;
  Timer stimer;
  double deliveryfee;
  double overalltotal;
  int start;
  int start1;
  int ins;

  String distance;
  Future<String> usr() async {
    var we = Uri.parse("https://gasapp123.000webhostapp.com/getmyorder.php");
    final respnse = await http.post(we, body: {"order_id": orderID});
    print(respnse.body);
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      loading = false;
      order_ID = '${userlogin.order_id}';
      productName = '${userlogin.product_name}';
      productPrice = '${userlogin.product_price}';
      sellerLat = double.parse('${userlogin.lat}');
      sellerLong = double.parse('${userlogin.longhi}');
      consumerLat = double.parse('${userlogin.consumer_lat}');
      consumerLong = double.parse('${userlogin.consumer_longh}');
      // orderstat = int.tryParse('${userlogin.orderStatus}');
      var distanceBetweenPoints = SphericalUtil.computeDistanceBetween(
              LatLng(sellerLat, sellerLong),
              LatLng(consumerLat, consumerLong)) /
          1000.0;
      distance = distanceBetweenPoints.toStringAsFixed(2);
      deliveryfee = double.parse(distance) * 7;
      overalltotal = deliveryfee + total + 35;
      path = '${userlogin.path}';

      if ('${userlogin.orderStatus}' == "0") {
        orderstat = "Waiting for the seller approval";
      } else if ('${userlogin.orderStatus}' == "1") {
        orderstat = "Seller Prepairing your Order";
        start = int.parse('${userlogin.start_time}');
      } else if ('${userlogin.orderStatus}' == "2") {
        orderstat = "Seller Reject your Order";
      } else if ('${userlogin.orderStatus}' == "3") {
        orderstat = "Succesfully Delivered";
      }
    });
  }

  Future getime() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      loading = false;

      if ('${userlogin.start_time}' != null) {
        start1 = int.parse('${userlogin.start_time}');
      }
      ;
    });
  }

  Future startTimer() {
    if (stimer != null) {
      stimer.cancel();
      stimer = null;
    } else {
      stimer = new Timer.periodic(
        const Duration(seconds: 60),
        (Timer stimer) => setState(
          () {
            if (start < 1) {
              stimer.cancel();
            } else {
              start = start - 1;
              updatetime();
            }
          },
        ),
      );
    }
  }

  Future updatetime() async {
    var tm = Uri.parse("https://gasapp123.000webhostapp.com/updatetimer.php");
    final respnse = await http
        .post(tm, body: {"start_time": "$start", "order_id": order_ID});
    print("time update: " + respnse.body);
  }

  @override
  void dispose() {
    stimer.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    startTimer();
    print("ORDER_ID: " + orderID);
    setState(() {
      getinfo();
      timer = Timer.periodic(Duration(seconds: 5), (Timer s) {
        getinfo();
        // updatetime();
      });
      timerss = Timer.periodic(Duration(seconds: 2), (Timer t) {
        getime();
        // updatetime();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            backgroundColor: Colors.grey[500],
            appBar: new AppBar(
                title: new Text("Your Order"),
                centerTitle: true,
                automaticallyImplyLeading: false),
            body: new Container(
              height: 670.0,
              padding: const EdgeInsets.all(20.0),
              child: new Card(
                child: new Center(
                    child: SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      Center(
                        child: Container(
                            height: 250,
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                'https://gasapp123.000webhostapp.com/' + path,
                                fit: BoxFit.cover,
                                scale: 1.0)),
                      ),
                      new Text(
                        "Order Number : " + orderID,
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "PRODUCT NAME : " + productName,
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "PRODUCT PRICE: " + productPrice,
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Quantity: " + quantity,
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Product Total: " + total.toString(),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Distance: " + distance + "km",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Standard Delivery Fee: 35",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Delivery Fee/km: " + deliveryfee.toString(),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Total : " + overalltotal.toString(),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          orderstat == "Succesfully Delivered"
                              ? new RaisedButton(
                                  child: Text("OK"),
                                  color: Colors.green,
                                  onPressed: () {
                                    cancelOrder();
                                  })
                              : new RaisedButton(
                                  child: Text("CANCEL ORDER"),
                                  color: Colors.red,
                                  onPressed: () {
                                    cancelOrder();
                                  }),
                        ],
                      ),
                      orderstat == "Succesfully Delivered"
                          ? new Text(
                              orderstat,
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.green),
                            )
                          : orderstat == "Seller Reject your Order"
                              ? new Text(
                                  orderstat,
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.red),
                                )
                              : orderstat == "Waiting for the seller approval"
                                  ? new Text(
                                      orderstat,
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.orangeAccent),
                                    )
                                  : Text(
                                      orderstat,
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.greenAccent),
                                    ),
                      orderstat == "Seller Prepairing your Order"
                          ? start1 == 0
                              ? Text(
                                  "Sorry for Delay pls Wait",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.red),
                                )
                              : Text(
                                  "$start1 min's",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.greenAccent),
                                )
                          : Text(""),
                    ],
                  ),
                )),
              ),
            ),
          );
  }

  Future cancelOrder() {
    if (orderstat == "Seller Prepairing your Order") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Cancel Order"),
            content:
                new Text("You can't cancel the order the \n  " + orderstat),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
            ],
          );
        },
      );
    } else if (orderstat == "Seller Reject your Order") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Cancel Order"),
            content: new Text("Sorry \n  " + orderstat),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("OK"),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer_map(
                                  consumer_username: consumer_username,
                                )));
                    var url = Uri.parse(
                        "https://gasapp123.000webhostapp.com/cancelOrder.php");
                    var result = await http.post(url, body: {
                      "order_id": orderID,
                    });
                    print(result.body);
                  }),
            ],
          );
        },
      );
    } else if (orderstat == "Waiting for the seller approval") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Cancel Order"),
            content: new Text("Are you sure ?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("YES"),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer_map(
                                  consumer_username: consumer_username,
                                )));
                    var url = Uri.parse(
                        "https://gasapp123.000webhostapp.com/cancelOrder.php");
                    var result = await http.post(url, body: {
                      "order_id": orderID,
                    });
                    print(result.body);
                  }),
              new FlatButton(
                  child: new Text("NO"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(orderstat),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer_map(
                                  consumer_username: consumer_username,
                                )));
                  }),
            ],
          );
        },
      );
    }
  }
}
