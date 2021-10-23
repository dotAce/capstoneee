import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:gasapp/src/consumerorder_Page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import 'package:http/http.dart' as http;

class Consumer_map extends StatefulWidget {
  _Consumer_mapState createState() => _Consumer_mapState(consumer_username);

  String consumer_username;
  Consumer_map({this.consumer_username});
}

class _Consumer_mapState extends State<Consumer_map> {
  final PopupController _popupController = PopupController();

  Position myloc;
  List data = [];
  // List data2 = [];
  bool loading = true;
  List<Marker> markers = [];
  // int index;
  // List<Text> textd = [];
  LatLng center;
  int intd = 0;
  // ignore: non_constant_identifier_names
  String consumer_username;
  _Consumer_mapState(this.consumer_username);
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //
  }

  final PopupController _popupLayerController = PopupController();
  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("MAP"),
              centerTitle: true,
            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  markers = List.from(markers);
                  // print(data);
                });
              },
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
                    accountName: Text(consumer_username),
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
                center: center,
                zoom: 18,

                interactive: true,
                onTap: (_) => _popupLayerController.hidePopup(),
                plugins: [
                  MarkerClusterPlugin(),
                ],
                // onTap: (_) => _popupController
                //     .hidePopup(), // Hide popup when the map is tapped.
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
                        point: new LatLng(myloc.latitude, myloc.longitude),
                        builder: (ctx) => GestureDetector(
                            onTap: () => debugPrint("Popup tap!"),
                            child: Container(
                              height: 10,
                              width: 50,
                              child: Text(
                                "Your Location",
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
                      point: new LatLng(myloc.latitude, myloc.longitude),
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_pin,
                            color: Colors.blue, size: 50),
                      ),
                    ),
                  ],
                ),
                MarkerClusterLayerOptions(
                  maxClusterRadius: 0,
                  markers: markers,
                  popupOptions: PopupOptions(
                      popupController: _popupController,
                      popupBuilder: (context, marker) {
                        String storename = "";
                        String sellerid = "";
                        for (int i = 0; i != data.length; i++) {
                          double dataLat;
                          double dataLong;
                          if (data[i]['lat'].toString().endsWith("0")) {
                            dataLat = double.parse(data[i]['lat']
                                .toString()
                                .substring(
                                    0, data[i]['lat'].toString().length - 1));
                            // print("Lat ends with 0");
                          } else {
                            dataLat = double.parse(data[i]['lat']);
                          }

                          if (data[i]['longhi'].toString().endsWith("0")) {
                            dataLong = double.parse(data[i]['longhi']
                                .toString()
                                .substring(0,
                                    data[i]['longhi'].toString().length - 1));
                            // print("long ends with zero");
                          } else {
                            dataLong = double.parse(data[i]['longhi']);
                          }

                          if (marker.point.latitude == dataLat &&
                              marker.point.longitude == dataLong) {
                            storename = data[i]['store_name'];
                            sellerid = data[i]['userid'];
                          }
                        }
                        return Container(
                          width: 100,
                          height: 50,
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () => debugPrint("Popup tap!"),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Consumerorder_Page(
                                          consumer_username: consumer_username,
                                          sellerid: sellerid,
                                          storename: storename,
                                          conlonghi: myloc.longitude,
                                          conlathi: myloc.latitude),
                                    ),
                                  );
                                },
                                child: Text(storename)),
                          ),
                        );
                      }),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                ),
              ],
            ),
          );
  }

  Future _getCurrentLocation() async {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    var currentLocation = Geolocator();
    currentLocation
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      var urls =
          Uri.parse("https://gasapp123.000webhostapp.com/getall_location.php");
      final response = await http.post(urls, body: {});
      // print(response.body);
      data = json.decode(response.body);
      for (int i = 0; i != data.length; i++) {
        var markerToAdd = Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            height: 40,
            width: 40,
            point: LatLng(
                double.parse(data[i]["lat"]), double.parse(data[i]["longhi"])),
            builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ));

        // var nametd = Text("Name of the Store ${data[i]["userid"]}");
        markers.add(markerToAdd);
      }

      setState(() {
        myloc = position;
        center = LatLng(position.latitude, position.longitude);
        loading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
