import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:gasapp/src/approval.dart';
import 'package:http/http.dart' as http;
import 'package:icon_badge/icon_badge.dart';
import '../model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'adminviewpayment.dart';

class adminhomepages extends StatefulWidget {
  adminhomepagesState createState() => adminhomepagesState(value);
  String value;
  bool loading = false;
  String userid;
  String status;
  String type;

  String path;
  // String quantity;

  adminhomepages({this.value});
}

// ignore: camel_case_types
class adminhomepagesState extends State<adminhomepages> {
  String value;
  adminhomepagesState(this.value);
  List data = [];
  String userid;
  Timer timer;
  String reqpay = "0";
  String sta = "not_verify";
  Future<List> getData() async {
    var urls =
        Uri.parse("https://gasapp123.000webhostapp.com/getnotverify.php");
    final response = await http.post(urls, body: {"status": sta});
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
    });
  }

  Future countreqpay() async {
    var wetf =
        Uri.parse("https://gasapp123.000webhostapp.com/countreqpayment.php");
    final noti = await http.post(wetf, body: {});
    var res = noti.body;

    // print("dfdf" + res);
    this.setState(() {
      reqpay = res.toString();
    });
  }

  @override
  initState() {
    super.initState();
    getinfo();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      countreqpay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN PANEL"),
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
              leading: IconBadge(
                icon: Icon(Icons.money),
                itemCount: int.parse(reqpay),
                badgeColor: Colors.red,
                itemColor: Colors.white,
                hideZero: true,
                maxCount: 99,
              ),
              title: Text('Seller payment'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new sellerpaymentrequest(
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

  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Approve(
                      list: list,
                      index: i,
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
                          Text("USERNAME : ${list[i]['username']}"),
                          Text("TYPE : ${list[i]['type']}"),
                          Text("STATUS : ${list[i]['status']}"),
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
