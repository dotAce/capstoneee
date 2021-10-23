import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:gasapp/src/update.dart';
import 'package:http/http.dart' as http;

import '../model.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  String value;
  Detail({this.index, this.list, value});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> {
  String value;
  String product_price;
  String product_name;

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
    var url = Uri.parse("https://gasapp123.000webhostapp.com/delete.php");
    var result = await http.post(url, body: {
      "product_id": '${widget.list[widget.index]['product_id']}',
    });
    var re = int.parse(result.body);
    if (re == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("DELETED SUCCESSFULL"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homepages(
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

  void confirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Are You sure want to delete '${widget.list[widget.index]['product_name']}'"),
          content: new Text(""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("YES"),
                onPressed: () {
                  deleteData();
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

  @override
  initState() {
    super.initState();
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(widget.list[widget.index]['product_name'])),
      body: new Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
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
                          'https://gasapp123.000webhostapp.com/' +
                              widget.list[widget.index]['path'],
                          fit: BoxFit.cover)),
                ),
                new Text(
                  "Product Name : ${widget.list[widget.index]['product_name']}",
                  style: new TextStyle(fontSize: 20.0),
                ),
                new Text(
                  "Procduct Price : ${widget.list[widget.index]['product_price']}",
                  style: new TextStyle(fontSize: 18.0),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text("EDIT"),
                      color: Colors.green,
                      onPressed: () =>
                          Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new EditData(
                          list: widget.list,
                          index: widget.index,
                          value: '${widget.list[widget.index]['username']}',
                        ),
                      )),
                    ),
                    new RaisedButton(
                        child: new Text("DELETE"),
                        color: Colors.red,
                        onPressed: () {
                          confirm();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
