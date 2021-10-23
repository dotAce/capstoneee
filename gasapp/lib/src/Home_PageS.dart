import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Login_Page.dart';
import 'package:gasapp/src/seller_payment.dart';
import 'package:gasapp/src/sellerhistorydone.dart';
import 'package:gasapp/src/sellerongoingTrans.dart';
import 'package:gasapp/src/sellervieworder.dart';
import 'package:http/http.dart' as http;
import 'package:icon_badge/icon_badge.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'Add_product.dart';
import 'detail.dart';

class homepages extends StatefulWidget {
  homepagesState createState() => homepagesState(value);
  String value;
  String userid;
  String product_name;
  String product_price;
  String path;
  // String quantity;

  homepages({this.value, String userid});
}

// ignore: camel_case_types
class homepagesState extends State<homepages> {
  String value;
  homepagesState(this.value);
  List data = [];
  String userid;
  String notif = "0";
  String ongoing = "0";
  String formatted;
  String day;
  String billingnof = "0";
  Timer timer;
  Timer timers;
  bool loading = true;
  String billing = "0";
  String startday;
  String startdate;
  String monthonlys;
  String paymentStatuss;
  String batday;
  Future<List> getData() async {
    var urls =
        Uri.parse("https://gasapp123.000webhostapp.com/getmyproduct.php");
    final response = await http.post(urls, body: {"userid": '$userid'});
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
      loading = false;
    });
  }

  Future countnotify() async {
    var wetf = Uri.parse("https://gasapp123.000webhostapp.com/countnotify.php");
    final noti = await http.post(wetf, body: {"selleruserid": userid});
    var res = noti.body;

    // print("dfdf" + res);
    this.setState(() {
      notif = res.toString();
    });
  }

  Future countongoing() async {
    var wetf =
        Uri.parse("https://gasapp123.000webhostapp.com/countongoing.php");
    final noti = await http.post(wetf, body: {"selleruserid": userid});
    var res = noti.body;

    // print("dfdf" + res);
    this.setState(() {
      ongoing = res.toString();
    });
  }

  // Future checkingbilling() async {
  //   var wetf = Uri.parse("https://blyana.000webhostapp.com/countongoing.php");
  //   final noti = await http.post(wetf, body: {"selleruserid": userid});
  //   var res = noti.body;

  //   // print("dfdf" + res);
  //   this.setState(() {
  //     billingnof = res.toString();
  //   });
  // }

  Future gettheday() async {
    var wetfr =
        Uri.parse("https://gasapp123.000webhostapp.com/getthesellerday.php");
    final notir = await http.post(wetfr, body: {"selleruserid": userid});
    var resr = json.decode(notir.body);
    Userlogin userlogin = new Userlogin.fromJson(resr[0]);
    this.setState(() {
      DateTime now = DateTime.now();
      formatted = DateFormat('yyyy-MM').format(now);
      String mon = DateFormat('MM').format(now);

      day = DateFormat('dd').format(now);
      if (day == '${userlogin.day}' &&
          '${userlogin.monthonly}' == mon &&
          formatted != '${userlogin.date}') {
        startday = '${userlogin.day}';
        startdate = '${userlogin.date}';
        billing = "1";
        updateusseraccountstatus();
      } else {
        billing = "0";
      }
    });
  }

  // Future verifyaccount() async {
  //   DateTime now = DateTime.now();
  //   monthonlys = DateFormat('MM').format(now);
  //   var wetfr = Uri.parse("https://blyana.000webhostapp.com/verify.php");
  //   final notir = await http.post(wetfr, body: {"seller_id": userid});
  //   var resr = json.decode(notir.body);
  //   Userlogin userlogin = new Userlogin.fromJson(resr[0]);
  //   this.setState(() {
  //     monthonlys = '${userlogin.monthonly}';
  //     paymentStatuss = '${userlogin.paymentStatus}';

  //     batday = '${userlogin.day}';
  //     if (monthonlys == monthonlys && batday == day) {
  //       if (paymentStatuss == "1") {
  //         billing = "0";
  //       } else if (paymentStatuss == "0") {
  //         updateusseraccountstatus();
  //       }
  //     } else if (resr == null) {
  //       updateusseraccountstatus();
  //     }
  //   });
  // }

  Future updateusseraccountstatus() async {
    var wetfr = Uri.parse(
        "https://gasapp123.000webhostapp.com/updateusseraccountstatus.php");
    final notirt = await http.post(wetfr, body: {"selleruserid": userid});
    var resrt = notirt.body;
    print("fdsdadsd :" + resrt);
  }

  @override
  initState() {
    super.initState();
    DateTime now = DateTime.now();
    formatted = DateFormat('yyyy-MM').format(now);
    getinfo();
    print(value);
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      countnotify();
      countongoing();
    });
    timers = Timer.periodic(Duration(seconds: 5), (Timer s) {
      gettheday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Products"),
              centerTitle: true,
            ),
            drawer: Drawer(
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
                      icon: Icon(Icons.notifications_none),
                      itemCount: int.parse(notif),
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                      hideZero: true,
                      maxCount: 99,
                    ),
                    title: Text('Notification'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new sellervieworder(
                                value: value,
                                userid: userid,
                              )));
                    },
                  ),
                  ListTile(
                    leading: IconBadge(
                      icon: Icon(Icons.work),
                      itemCount: int.parse(ongoing),
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                      hideZero: true,
                      maxCount: 99,
                    ),
                    title: Text('Ongoing Transaction'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new sellerongoingT(
                                value: value,
                              )));
                    },
                  ),
                  ListTile(
                      leading: IconBadge(
                        icon: Icon(Icons.money),
                        itemCount: int.parse(billing),
                        badgeColor: Colors.red,
                        itemColor: Colors.white,
                        hideZero: true,
                        maxCount: 99,
                      ),
                      title: Text('Pay'),
                      onTap: () {
                        billing != "0"
                            ? Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new SellerPayment(
                                        value: value,
                                        day: day,
                                        formatted: formatted,
                                        startdate: startdate,
                                        startday: startday)))
                            : null;
                        // ignore: unnecessary_statements
                      }),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.history),
                    title: Text('History'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new sellerhistoryDone(value: value)));
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
            floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new createPage(value: value)));
                }),
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
                builder: (BuildContext context) => new Detail(
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
                          height: 250,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                              'https://gasapp123.000webhostapp.com/' +
                                  '${list[i]['path']}',
                              fit: BoxFit.cover,
                              scale: 1.0)),
                    ),
                    Center(
                        child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Product Name : ${list[i]['product_name']}"),
                          Text("Product Price : ${list[i]['product_price']}"),
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
