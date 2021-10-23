import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class Consumerorder_Page extends StatefulWidget {
  Consumerorder_PageState createState() => Consumerorder_PageState(
      consumer_username, sellerid, storename, conlonghi, conlathi);
  String storename;
  // ignore: non_constant_identifier_names
  String consumer_username;
  String sellerid;
  bool loading = false;
  double conlonghi;
  double conlathi;

  String path;
  // String quantity;

  Consumerorder_Page(
      {this.consumer_username,
      this.sellerid,
      this.storename,
      this.conlonghi,
      this.conlathi});
}

// ignore: camel_case_types
class Consumerorder_PageState extends State<Consumerorder_Page> {
  String consumer_username;
  String sellerid;
  String storename;
  String cunsumercontnum;
  double conlonghi;
  double conlathi;
  bool loading = true;
  Consumerorder_PageState(this.consumer_username, this.sellerid, this.storename,
      this.conlonghi, this.conlathi);
  List data = [];
  String consumer_userid;
  Future<List> getData() async {
    var urls = Uri.parse("https://gasapp123.000webhostapp.com/getall.php");
    final response = await http.post(urls, body: {"sellerid": sellerid});
    // print(response.body);
    // print(json.decode(response.body));
    return data = json.decode(response.body);
  }

  Future<String> usr() async {
    var we = Uri.parse("https://gasapp123.000webhostapp.com/getinfo.php");
    final respnse = await http.post(we, body: {"username": consumer_username});

    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);

      consumer_userid = '${userlogin.userid}';
      cunsumercontnum = '${userlogin.contactnum}';
      if (consumer_userid != null) {
        consumer_userid = '${userlogin.userid}';
        cunsumercontnum = '${userlogin.contactnum}';
        loading = false;
      }
    });
  }

  @override
  initState() {
    super.initState();
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text(storename),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            body: new FutureBuilder<List>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? new ItemList(
                        list: snapshot.data,
                        consumer_userid: consumer_userid,
                        conlathi: conlathi,
                        conlonghi: conlonghi,
                        consumer_username: consumer_username,
                        cunsumercontnum: cunsumercontnum)
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
  _ItemListState createState() => _ItemListState(
      consumer_userid, conlathi, conlonghi, consumer_username, cunsumercontnum);
  final List list;
  double conlathi;
  double conlonghi;
  String consumer_userid;
  String cunsumercontnum;
  String consumer_username;
  ItemList(
      {this.list,
      this.consumer_userid,
      this.conlathi,
      this.conlonghi,
      this.consumer_username,
      this.cunsumercontnum});
}

class _ItemListState extends State<ItemList> {
  String consumer_userid;
  bool loading = false;
  String consumer_username;
  double conlathi;
  double conlonghi;
  String cunsumercontnum;
  String distance;
  double deliveryfee;
  double overalltotal;
  String formatted;
  _ItemListState(this.consumer_userid, this.conlathi, this.conlonghi,
      this.consumer_username, this.cunsumercontnum);

  @override
  initState() {
    super.initState();
    this.setState(() {
      DateTime now = DateTime.now();
      formatted = DateFormat('yyyy-MM').format(now);
    });
  }

  TextEditingController quantity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            itemBuilder: (context, i) {
              return new Container(
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
                                    '${widget.list[i]['path']}',
                                fit: BoxFit.cover,
                                scale: 1.0,
                              )),
                        ),
                        Center(
                            child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("SUPPLIER ID : ${widget.list[i]['userid']}"),
                              // Text("SUPPLIER : ${widget.list[i]['username']}"),
                              Text(
                                  "Product Name : ${widget.list[i]['product_name']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "Product Price : ${widget.list[i]['product_price']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                        Center(
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 125, right: 125),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NumberInputWithIncrementDecrement(
                                    controller: quantity,
                                    initialValue: 1,
                                    // scaleHeight: 0.75,
                                    // scaleWidth: 0.50,
                                    incIcon: Icons.add,
                                    decIcon: Icons.remove),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            new RaisedButton(
                                child: new Text("ORDER NOW"),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  DateTime now = DateTime.now();
                                  final String formatted =
                                      DateFormat('yyyyMMddHms').format(now);

                                  final String month =
                                      DateFormat('yyyy-MM').format(now);
                                  int total = int.parse(quantity.text) *
                                      int.parse(
                                          "${widget.list[i]['product_price']}");
                                  print("TOTAL: " + total.toString());

                                  double sellerLat =
                                      double.parse('${widget.list[i]['lat']}');
                                  double sellerLong = double.parse(
                                      '${widget.list[i]['longhi']}');
                                  var distanceBetweenPoints =
                                      SphericalUtil.computeDistanceBetween(
                                              LatLng(sellerLat, sellerLong),
                                              LatLng(conlathi, conlonghi)) /
                                          1000.0;
                                  distance =
                                      distanceBetweenPoints.toStringAsFixed(2);
                                  deliveryfee =
                                      (double.parse(distance) * 7) + 35;
                                  overalltotal = deliveryfee + total;
                                  print(formatted);
                                  print(consumer_username);
                                  print(quantity.text);
                                  print(total);
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Order(
                                                  orderID: formatted,
                                                  consumer_username:
                                                      consumer_username,
                                                  quantity: quantity.text,
                                                  total: total)));
                                  var url = Uri.parse(
                                      "https://gasapp123.000webhostapp.com/createorder.php");
                                  var result = await http.post(url, body: {
                                    "consumer_userid": consumer_userid,
                                    "Productid":
                                        "${widget.list[i]['product_id']}",
                                    "Sellerid": "${widget.list[i]['userid']}",
                                    "orderId": formatted,
                                    "consumer_lat": conlathi.toString(),
                                    "consumer_longh": conlonghi.toString(),
                                    "consumer_number": cunsumercontnum,
                                    "quantity": quantity.text,
                                    "producttotal": total.toString(),
                                    "deliveryfee": deliveryfee.toString(),
                                    "total": overalltotal.toString(),
                                    "month": month
                                  });
                                  print(result.body);

                                  // print(result.body);
                                }),
                          ],
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )),
              );
            },
          );
  }
}
