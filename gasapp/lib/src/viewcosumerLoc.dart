import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:latlong/latlong.dart';

import 'package:http/http.dart' as http;

class CustomerLoca extends StatefulWidget {
  _CustomerLocaState createState() => _CustomerLocaState(
      value, customerlat, customerlong, sellerlat, sellerlong, orderID);
  String value;
  String customerlat;
  String customerlong;
  String sellerlat;
  String sellerlong;
  String orderID;
  CustomerLoca(
      {this.value,
      this.customerlat,
      this.customerlong,
      this.sellerlat,
      this.sellerlong,
      this.orderID});
}

class _CustomerLocaState extends State<CustomerLoca> {
  final PopupController _popupController = PopupController();

  bool loading = false;
  String value;
  String customerlat;
  String customerlong;
  String sellerlat;
  String sellerlong;
  String orderID;
  _CustomerLocaState(this.value, this.customerlat, this.customerlong,
      this.sellerlat, this.sellerlong, this.orderID);
  String ch;
  @override
  void initState() {
    super.initState();
  }

  Future des() async {
    if (ch == "3") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => homepages(value: value)));
      var url = Uri.parse(
          "https://gasapp123.000webhostapp.com/updateorderStatus.php");
      var result = await http.post(url, body: {
        "orderStatus": ch,
        "order_id": orderID,
      });
    } else if (ch == "2") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => homepages(value: value)));
      var url = Uri.parse(
          "https://gasapp123.000webhostapp.com/updateorderStatus.php");
      var result = await http.post(url, body: {
        "orderStatus": ch,
        "order_id": orderID,
      });
      print(result.body);
    }
  }

  final PopupController _popupLayerController = PopupController();
  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Customer Location"),
              centerTitle: true,
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: () {
                      this.setState(() {
                        ch = "3";
                      });
                      des();
                    },
                    label: Text("Done"),
                    icon: Icon(Icons.navigate_before),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      this.setState(() {
                        ch = "2";
                      });
                      des();
                    },
                    label: Text("Reject"),
                    icon: Icon(Icons.navigate_next),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                ],
              ),
            ),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.

              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(value),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new homepages(
                                    value: value,
                                  )));
                    },
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.powerOff),
                    title: Text('Logout'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new loginPage()));
                    },
                  ),
                ],
              ),
            ),

            // floatingActionButton: _buttonToSwitchSnap(context),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

            body: FlutterMap(
              options: MapOptions(
                center: LatLng(
                    double.parse(customerlat), double.parse(customerlong)),
                zoom: 18,
                interactive: true,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/blyanaarthur/cknr46s5t0hyd17nmrmpj3bet/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYmx5YW5hYXJ0aHVyIiwiYSI6ImNrbmM4bGhxbjB2dTYycG8wdzh0YWJobXEifQ.PXtKMm-1GqL7xNJq56iBDQ",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiYmx5YW5hYXJ0aHVyIiwiYSI6ImNrbmM4bGhxbjB2dTYycG8wdzh0YWJobXEifQ.PXtKMm-1GqL7xNJq56iBDQ',
                    'id': 'mapbox.mapbox-streets-v11',
                  },
                ),
                MarkerLayerOptions(
                  markers: <Marker>[
                    new Marker(
                        anchorPos: AnchorPos.align(AnchorAlign.center),
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(double.parse(customerlat),
                            double.parse(customerlong)),
                        builder: (ctx) => GestureDetector(
                            onTap: () => debugPrint("Popup tap!"),
                            child: Container(
                              height: 10,
                              width: 50,
                              child: Text(
                                "Customer Location",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))),
                    new Marker(
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(double.parse(customerlat),
                          double.parse(customerlong)),
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_pin,
                            color: Colors.red, size: 50),
                      ),
                    ),
                    new Marker(
                        anchorPos: AnchorPos.align(AnchorAlign.center),
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(
                            double.parse(sellerlat), double.parse(sellerlong)),
                        builder: (ctx) => GestureDetector(
                            onTap: () => debugPrint("Popup tap!"),
                            child: Container(
                              height: 10,
                              width: 50,
                              child: Text(
                                "Store Location",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))),
                    new Marker(
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(
                          double.parse(sellerlat), double.parse(sellerlong)),
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_pin,
                            color: Colors.blue, size: 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
