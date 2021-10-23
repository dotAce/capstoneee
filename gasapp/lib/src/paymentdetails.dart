import 'package:flutter/material.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'adminviewpayment.dart';

class paymentDetail extends StatefulWidget {
  List list;
  int index;
  String value;
  paymentDetail({this.index, this.list, value});
  @override
  _paymentDetailState createState() => new _paymentDetailState();
}

class _paymentDetailState extends State<paymentDetail> {
  String value;
  String product_price;
  String product_name;
  bool loading = false;
  String monthonly;
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
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : new Scaffold(
            appBar: new AppBar(
              title: new Text("Payment Info"),
              centerTitle: true,
            ),
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
                              'https://gasapp123.000webhostapp.com/payment/' +
                                  widget.list[widget.index]['name'],
                              fit: BoxFit.cover,
                              scale: 1.0,
                            )),
                      ),
                      new Text(
                        "UserName : ${widget.list[widget.index]['username']}",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Text(
                        "Seller ID : ${widget.list[widget.index]['seller_id']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Month : ${widget.list[widget.index]['month_pay']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Amount : ${widget.list[widget.index]['amount']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new RaisedButton(
                              child: new Text("Accept"),
                              color: Colors.green,
                              onPressed: () {
                                this.setState(() {
                                  loading = true;
                                  accept();
                                });
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

  void accept() async {
    DateTime now = DateTime.now();
    monthonly = DateFormat('MM').format(now);
    int addone = int.parse(monthonly) + 1;
    var url = Uri.parse(
        "https://gasapp123.000webhostapp.com/updatepaymentstatus.php");
    var result = await http.post(url, body: {
      "month_pay": '${widget.list[widget.index]['month_pay']}',
      "username": '${widget.list[widget.index]['username']}',
      "monthonly": addone.toString()
    });

    var re = int.parse(result.body);
    print(value);
    if (re == 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new sellerpaymentrequest(
                value: "admin",
              )));
    }
  }
}
