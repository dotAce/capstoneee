import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:http/http.dart' as http;
import '../model.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class sellerhistoryDone extends StatefulWidget {
  sellerhistoryDoneState createState() => sellerhistoryDoneState(value);
  String value;
  String userid;
  bool loading = false;
  sellerhistoryDone({this.value});
}

// ignore: camel_case_types
class sellerhistoryDoneState extends State<sellerhistoryDone> {
  String value;
  sellerhistoryDoneState(this.value);
  var adad;
  Timer timer;
  String userid;
  List data = [];
  Future<List> getData() async {
    var urls = Uri.parse(
        "https://gasapp123.000webhostapp.com/getsellerhistoryDone.php");
    final response = await http.post(urls, body: {"sellerid": userid});
    print(response.body);
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

  @override
  initState() {
    super.initState();
    getinfo();

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      this.setState(() {
        getData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
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

class ItemList extends StatefulWidget {
  final List list;
  String value;
  ItemList({this.list, this.value});

  _ItemListState createState() => _ItemListState(value);
}

class _ItemListState extends State<ItemList> {
  _ItemListState(this.value);
  bool loading = false;
  String id;
  String value;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : new ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            itemBuilder: (context, i) {
              return new Container(
                child: new GestureDetector(
                  onTap: () {},
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
                                Text("Order ID : ${widget.list[i]['order_id']}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.redAccent)),
                                Text(
                                    "Customer ID : ${widget.list[i]['Consumer_id']}"),
                                Text(
                                    "Customer Contact # : ${widget.list[i]['consumer_number']}"),
                                Text(
                                    "Product Name : ${widget.list[i]['product_name']}"),
                                Text(
                                    "Product Price : ${widget.list[i]['product_price']}"),
                                Text(
                                    "Quantity : ${widget.list[i]['quantity']}"),
                                Text("Total : ${widget.list[i]['total']}"),
                                Text("Status : Done}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.green)),
                              ],
                            ),
                          )),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )),
                ),
              );
            },
          );
  }

  Future reject() async {
    String st = "2";
    var url =
        Uri.parse("https://gasapp123.000webhostapp.com/updateorderStatus.php");
    var result = await http.post(url, body: {
      "orderStatus": st,
      "order_id": id,
    });

    var re = int.parse(result.body);
    print(re);
    if (re == 1) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
