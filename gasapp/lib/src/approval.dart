import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model.dart';
import 'Adminhomepage.dart';

class Approve extends StatefulWidget {
  List list;
  int index;
  String value;
  Approve({this.index, this.list, value});
  @override
  _ApproveState createState() => new _ApproveState();
}

class _ApproveState extends State<Approve> {
  String value;
  String type;
  String status;

  Future<String> usr() async {
    var wer = Uri.parse("https://gasapp123.000webhostapp.com/getinfoo.php");
    final respnse = await http
        .post(wer, body: {"userid": '${widget.list[widget.index]['userid']}'});
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      value = '${userlogin.username}';
      // print(value);
    });
  }

  void deleteData() async {
    var url = Uri.parse("https://gasapp123.000webhostapp.com/admindelete.php");
    var result = await http.post(url, body: {
      "userid": '${widget.list[widget.index]['userid']}',
    });
    var re = int.parse(result.body);
    if (re == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("DELETE SUCCESSFULL"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => adminhomepages(
                                value: value,
                              )));
                  setState(
                    () => loading = true,
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  void confirm() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Are You sure want to delete '${widget.list[widget.index]['username']}'"),
          content: new Text(""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("YES"),
                onPressed: () {
                  deleteData();
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(
                    () => loading = true,
                  );
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
  }

  void approval() async {
    var url = Uri.parse("https://gasapp123.000webhostapp.com/adminupdate.php");
    var result = await http.post(url, body: {
      "userid": '${widget.list[widget.index]['userid']}',
      "username": '${widget.list[widget.index]['username']}',
      "lat": lat.text,
      "longhi": longhi.text,
      "store_name": store_name.text,
      "user_date": formatted,
      "paymentday": "30",
      "accountStatus": "1",
      "monthonly": monthonly
    });
    var re = int.parse(result.body);
    if (re == 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("APPROVED SUCCESSFULL"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => adminhomepages(
                                value: value,
                              )));
                },
              ),
            ],
          );
        },
      );
    }
  }

  void apconfirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Are You sure want to CONFIRM '${widget.list[widget.index]['username']}'"),
          content: new Text(""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("YES"),
                onPressed: () {
                  approval();
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(
                    () => loading = true,
                  );
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
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController lat = TextEditingController();
  TextEditingController longhi = TextEditingController();
  TextEditingController store_name = TextEditingController();
  bool loading = false;
  String formatted;
  String day;
  String monthonly;

  @override
  initState() {
    super.initState();
    getinfo();
    this.setState(() {
      DateTime now = DateTime.now();
      formatted = DateFormat('yyyy-MM').format(now);

      monthonly = DateFormat('MM').format(now);
      day = DateFormat('dd').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: new AppBar(
              title: new Text(widget.list[widget.index]['username']),
              centerTitle: true,
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Container(
                          height: 570.0,
                          padding: const EdgeInsets.all(20.0),
                          child: new Card(
                            child: new Center(
                              child: new Column(
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                  ),
                                  new Text(
                                    "USERNAME : ${widget.list[widget.index]['username']}",
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  new Text(
                                    "TYPE : ${widget.list[widget.index]['type']}",
                                    style: new TextStyle(fontSize: 18.0),
                                  ),
                                  new Text(
                                    "STATUS : ${widget.list[widget.index]['status']}",
                                    style: new TextStyle(fontSize: 18.0),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0,
                                              right: 50.0,
                                              top: 10.0),
                                          child: new Container(
                                            alignment: Alignment.center,
                                            height: 70.0,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter Store Name';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Store Name",
                                                icon: FaIcon(
                                                    FontAwesomeIcons.storeAlt,
                                                    color: Colors.red[800]),
                                              ),
                                              controller: store_name,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0,
                                              right: 50.0,
                                              top: 10.0),
                                          child: new Container(
                                            alignment: Alignment.center,
                                            height: 70.0,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter the Latitud';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Latitud",
                                                icon: FaIcon(
                                                    FontAwesomeIcons.streetView,
                                                    color: Colors.red[800]),
                                              ),
                                              controller: lat,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0,
                                              right: 50.0,
                                              top: 10.0),
                                          child: new Container(
                                            alignment: Alignment.center,
                                            height: 70.0,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter the Longhitud';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Longhitud",
                                                icon: FaIcon(
                                                    FontAwesomeIcons.streetView,
                                                    color: Colors.red[800]),
                                              ),
                                              controller: longhi,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new RaisedButton(
                                          child: new Text("APPROVE"),
                                          color: Colors.green,
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              apconfirm();
                                              setState(
                                                () => loading = true,
                                              );
                                            }
                                          }),
                                      new RaisedButton(
                                          child: new Text("DELETE"),
                                          color: Colors.red,
                                          onPressed: () {
                                            confirm();
                                            setState(
                                              () => loading = true,
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )))),
          );
  }
}
