import 'package:flutter/material.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:gasapp/src/sellerongoingTrans.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart';

class ApproveOrder extends StatefulWidget {
  _ApproveOrderState createState() => _ApproveOrderState(values);
  List list;
  int index;
  String values;
  ApproveOrder({
    this.index,
    this.list,
    this.values,
  });
}

class _ApproveOrderState extends State<ApproveOrder> {
  String values;
  String product_price;
  String product_name;
  String desOrd;
  String distance;
  String value;
  bool loading = false;
  _ApproveOrderState(this.values);
  final _formKey = GlobalKey<FormState>();
  TextEditingController start_time = TextEditingController();
  @override
  initState() {
    super.initState();
    this.setState(() {
      var distanceBetweenPoints = SphericalUtil.computeDistanceBetween(
              LatLng(double.parse('${widget.list[widget.index]['lat']}'),
                  double.parse('${widget.list[widget.index]['longhi']}')),
              LatLng(
                  double.parse('${widget.list[widget.index]['consumer_lat']}'),
                  double.parse(
                      '${widget.list[widget.index]['consumer_longh']}'))) /
          1000.0;
      distance = distanceBetweenPoints.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: new AppBar(
              title: new Text(widget.list[widget.index]['order_id']),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
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
                      Center(
                        child: Container(
                            height: 250,
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                'https://gasapp123.000webhostapp.com/' +
                                    widget.list[widget.index]['path'],
                                scale: 1.0,
                                fit: BoxFit.cover)),
                      ),
                      new Text(
                        "Distance : " + distance + "km",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Text(
                        "Customer ID : ${widget.list[widget.index]['Consumer_id']}",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Text(
                        "Customer Contact # : ${widget.list[widget.index]['consumer_number']}",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Text(
                        "Product Name : ${widget.list[widget.index]['product_name']}",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Text(
                        "Procduct Price : ${widget.list[widget.index]['product_price']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Quantity : ${widget.list[widget.index]['quantity']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        "Total : ${widget.list[widget.index]['total']}",
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new RaisedButton(
                              child: new Text("Ready"),
                              color: Colors.green,
                              onPressed: () {
                                this.setState(() {
                                  desOrd = "1";
                                });
                                settime();
                              }),
                          new RaisedButton(
                              child: new Text("Reject"),
                              color: Colors.red,
                              onPressed: () {
                                this.setState(() {
                                  desOrd = "2";
                                  loading = true;
                                });
                                orderConformation();
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
          );
  }

  Future orderConformation() async {
    if (desOrd == "1") {
      var url = Uri.parse(
          "https://gasapp123.000webhostapp.com/updateorderStatus.php");
      var result = await http.post(url, body: {
        "orderStatus": desOrd,
        "order_id": widget.list[widget.index]['order_id'],
      });
      var re = int.parse(result.body);

      if (re == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => sellerongoingT(value: values)));
      }
    } else if (desOrd == "2") {
      var url = Uri.parse(
          "https://gasapp123.000webhostapp.com/updateorderStatus.php");
      var result = await http.post(url, body: {
        "orderStatus": desOrd,
        "order_id": widget.list[widget.index]['order_id'],
      });
      var re = int.parse(result.body);
      if (re == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => homepages(value: values)));
      }
    }
  }

  Future settime() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
            key: _formKey,
            child: AlertDialog(
              title: new Text("Enter Estimate time in Minute's"),
              content: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Time Required!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Time",
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  value = text;
                },
                controller: start_time,
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                // new Row(

                new FlatButton(
                    child: new Text("Procces"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        orderConformation();
                        this.setState(
                          () => loading = true,
                        );
                        Navigator.of(context, rootNavigator: true).pop();
                        var url = Uri.parse(
                            "https://gasapp123.000webhostapp.com/insertTime.php");
                        var result = await http.post(url, body: {
                          "start_time": start_time.text,
                          "order_id": widget.list[widget.index]['order_id'],
                        });
                      }
                    }),
                new FlatButton(
                    child: new Text("Back"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ));
      },
    );
  }
}
