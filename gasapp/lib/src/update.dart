import 'package:http/http.dart' as http;
import 'home_pages.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  String value;

  EditData({this.list, this.index, this.value});

  @override
  _EditDataState createState() => new _EditDataState(this.value);
}

class _EditDataState extends State<EditData> {
  //date and time
  String value;

  _EditDataState(this.value);

  final _formKey = GlobalKey<FormState>();
  TextEditingController productname = TextEditingController();
  TextEditingController productprice = TextEditingController();

  @override
  void initState() {
    productname = new TextEditingController(
        text: widget.list[widget.index]['product_name']);
    productprice = new TextEditingController(
        text: widget.list[widget.index]['product_price']);
    // print(productprice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT DATA'),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      child: new Container(
                        alignment: Alignment.center,
                        height: 70.0,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Procduct Name Required.!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Name',
                            labelStyle: textStyle,
                            icon: Icon(Icons.shopping_cart),
                          ),
                          controller: productname,
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
                          left: 40.0, right: 40.0, top: 10.0),
                      child: new Container(
                        alignment: Alignment.center,
                        height: 70.0,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Procduct Price Required.!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Price',
                            labelStyle: textStyle,
                            icon: Icon(Icons.attach_money),
                          ),
                          controller: productprice,
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
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new Container(
                        child: Material(
                          // borderRadius: BorderRadius.circular(40.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                editData();
                              }
                            },
                            minWidth: 40.0,
                            height: 30.0,
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new Container(
                        child: Material(
                          // borderRadius: BorderRadius.circular(40.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            minWidth: 40.0,
                            height: 30.0,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editData() async {
    var url = Uri.parse("https://gasapp123.000webhostapp.com/update.php");
    var result = await http.post(url, body: {
      "product_id": '${widget.list[widget.index]['product_id']}',
      "product_name": productname.text,
      "product_price": productprice.text,
    });
    var res = int.parse(result.body);
    if (res == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("SUCCESSFULLY UPDATED"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new homepages(
                            value: value,
                          )));
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error UPDATING"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
            ],
          );
        },
      );
    }
  }
}
