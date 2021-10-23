import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:gasapp/src/orderApproval.dart';
import 'package:http/http.dart' as http;
import '../model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'Home_PageS.dart';

class sellervieworder extends StatefulWidget {
  sellervieworderState createState() => sellervieworderState(value, userid);
  String value;
  String userid;
  bool loading = false;
  String status;
  String type;

  sellervieworder({this.value, this.userid});
}

// ignore: camel_case_types
class sellervieworderState extends State<sellervieworder> {
  String value;
  String userid;
  String order_ID;
  String productName;
  String productPrice;
  String orderstat;
  String path;
  String consumerid;
  String loc_long;
  String loc_lat;
  String quantity;
  String total;
  sellervieworderState(this.value, this.userid);
  List data = [];
  Future<List> getData() async {
    var urls =
        Uri.parse("https://gasapp123.000webhostapp.com/sellerviewOrder.php");
    final response = await http.post(urls, body: {"sellerid": userid});
    // print(response.body);
    return data = json.decode(response.body);
  }

  Future<String> usr() async {
    var we = Uri.parse("https://gasapp123.000webhostapp.com/getinfo.php");
    final respnse = await http.post(we, body: {"username": value});
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      userid = '${userlogin.userid}';
      consumerid = '${userlogin.Consumer_id}';
      order_ID = '${userlogin.order_id}';
      productName = '${userlogin.product_name}';
      productPrice = '${userlogin.product_price}';
      path = '${userlogin.path}';
      loc_lat = '${userlogin.consumer_lat}';
      loc_long = '${userlogin.consumer_longh}';
      quantity = '${userlogin.quantity}';
      total = '${userlogin.total}';
    });
  }

  @override
  initState() {
    super.initState();
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Notification"),
        centerTitle: true,
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
              accountEmail: Text(value + "@gmail.com"),
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

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new loginPage()));
              },
            ),
          ],
        ),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                  value: value,
                )
              : new Center(
                  child: SpinKitChasingDots(
                    color: Colors.blue,
                  ),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  String value;
  ItemList({this.list, this.value});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new ApproveOrder(
                      list: list,
                      index: i,
                      values: value,
                    ))),
            child: new Card(
                color: Colors.grey[500],
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order ID : ${list[i]['order_id']}",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.redAccent)),
                          Text("Customer ID : ${list[i]['Consumer_id']}"),
                          Text(
                              "Customer Contact # : ${list[i]['consumer_number']}"),
                          Text("Product Name : ${list[i]['product_name']}"),
                          Text("Product Price : ${list[i]['product_price']}"),
                          Text("Quantity : ${list[i]['quantity']}"),
                          Text("Total : ${list[i]['total']}"),
                        ],
                      ),
                    ))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
          ),
        );
      },
    );
  }
}
