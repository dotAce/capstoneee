import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:gasapp/src/paymentdetails.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

import 'Adminhomepage.dart';

class sellerpaymentrequest extends StatefulWidget {
  sellerpaymentrequestState createState() => sellerpaymentrequestState(value);
  String value;
  String userid;
  bool loading = false;
  sellerpaymentrequest({this.value});
}

// ignore: camel_case_types
class sellerpaymentrequestState extends State<sellerpaymentrequest> {
  String value;
  sellerpaymentrequestState(this.value);
  var adad;
  Timer timer;
  String userid;
  List data = [];
  bool loading = false;
  Future<List> getData() async {
    var urls = Uri.parse(
        "https://gasapp123.000webhostapp.com/getallsellerrequestpayment.php");
    final response = await http.post(urls, body: {});
    print(response.body);
    if (response.body != null) {
      loading = false;
      return data = json.decode(response.body);
    } else {}
  }

  @override
  initState() {
    super.initState();

    this.setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Seller Payment Request"),
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
                              builder: (context) => new adminhomepages(
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
                builder: (BuildContext context) => new paymentDetail(
                      list: list,
                      index: i,
                      value: value,
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
                          Text("Username : ${list[i]['username']}"),
                          Text("Seller ID : ${list[i]['seller_id']}"),
                          Text("Month : ${list[i]['month_pay']}"),
                          Text("Amount : ${list[i]['amount']}"),
                        ],
                      ),
                    ))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
            // Card(
            //   child: new Column(
            //     children: <Widget>[
            //       new ListTile(
            //         title: new Text(list[i]['product_name'],
            //             style: TextStyle(
            //                 color: Colors.red.withOpacity(0.6),
            //                 fontWeight: FontWeight.bold)),
            //         // leading: new Icon(
            //         //   Icons.list,
            //         // ),
            //         subtitle: new Text(
            //             "Date : ${list[i]['product_name']}\nTime : ${list[i]['product_name']}"),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
