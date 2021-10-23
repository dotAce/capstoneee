import 'dart:async';
import 'dart:io';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/Home_PageS.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'start_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
// import 'package:intl/intl.dart';
import 'dart:convert';
import '../model.dart';

class SellerPayment extends StatefulWidget {
  _SellerPaymentState createState() =>
      _SellerPaymentState(value, day, formatted, startday, startdate);
  String value;
  String day;
  String formatted;
  String startday;

  String startdate;
  SellerPayment(
      {this.value, this.day, this.formatted, this.startday, this.startdate});
}

class _SellerPaymentState extends State<SellerPayment> {
  String userid;
  String value;
  String startday;

  String startdate;

  String day;
  String formatted;
  _SellerPaymentState(
      this.value, this.day, this.formatted, this.startday, this.startdate);
  final _formKey = GlobalKey<FormState>();
  TextEditingController productname = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String monthlytotal;
  bool loading = true;
  double totalpayment;
  Timer timer;
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        chooseImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      chooseImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Final picker = ImagePicker();

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);

      return;
    }
    String fileName = tmpFile.path.split('/').last;

    if (upload(fileName) == null) {
      upload(fileName);
      // Future.delayed(Duration(milliseconds: 300), () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => homepages(value: value)));
      // });
    }
    // print(upload(fileName));
  }

  upload(String fileName) async {
    var uploadEndPoint = Uri.parse(
        "https://gasapp123.000webhostapp.com/selleruploadreceipt.php");
    var xname = (value + "_" + formatted + ".jpg");
    var re = await http.post(uploadEndPoint, body: {
      "image": base64Image,
      "userid": userid,
      "username": value,
      "month": formatted,
      "name": xname,
      "amount": totalpayment.toStringAsFixed(2),
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      print(userid);
      print(value);
      print(formatted);
      print(xname);
      print(totalpayment.toStringAsFixed(2));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => homepages(value: value, userid: userid)));
    }).catchError((error) {
      setStatus(error);
    });
    // print(result(re.body));
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Row(children: <Widget>[
              Expanded(
                child: Image.file(
                  snapshot.data,
                  // height: 200,
                  // fit: BoxFit.scaleDown,
                ),
              )
            ]),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Flexible(
              child: Row(children: <Widget>[
            Expanded(
              child: Text(
                'No Image Selected',
                textAlign: TextAlign.center,
              ),
            )
          ]));
        }
      },
    );
  }

  Future<String> usr() async {
    var we = Uri.parse("https://gasapp123.000webhostapp.com/getinfo.php");
    final respnse = await http.post(we, body: {"username": value});
    print(respnse.body);
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      userid = '${userlogin.userid}';

      sellersumofmonthlypayment();
    });
  }

  Future sellersumofmonthlypayment() async {
    var wetf = Uri.parse(
        "https://gasapp123.000webhostapp.com/sellersumofmonthlypayment.php");
    final noti = await http
        .post(wetf, body: {"seller_id": userid, "monthof": formatted});
    var res = noti.body;
    print(res);
    this.setState(() {
      if (res != null) {
        monthlytotal = res;
        totalpayment = double.parse(monthlytotal) * 0.10;
        loading = false;
      } else {
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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Monthly Payment'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
            backgroundColor: Colors.white,
            body: Center(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(children: <Widget>[
                      showImage(),
                    ]),
                    new Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 20.0),
                        child: Container(
                          child: RaisedButton.icon(
                            onPressed: () {
                              _showPicker(
                                  context); // call choose image function
                            },
                            icon: Icon(Icons.folder_open),
                            label: Text("CHOOSE IMAGE"),
                            color: Colors.deepOrangeAccent,
                            colorBrightness: Brightness.dark,
                          ),
                        ),
                      ))
                    ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Row(children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Container(
                                    child: Text(
                                      "Date Started :" +
                                          startdate +
                                          "-" +
                                          startday,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Container(
                                    child: Text(
                                      "Month of :" + formatted,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Container(
                                    child: Text(
                                      "Total Income : $monthlytotal",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Container(
                                    child: Text(
                                      "10% of your total income of the month ",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                          new Row(children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Container(
                                    child: Text(
                                      "Total payment :" +
                                          totalpayment.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                        ]),
                    new Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 20.0),
                        child: Container(
                            //show upload button after choosing image
                            //if uploadimage is null then show empty container

                            //elese show uplaod button
                            child: RaisedButton.icon(
                          onPressed: () {
                            startUpload();
                          },
                          //start uploading image
                          //
                          icon: Icon(Icons.file_upload),
                          label: Text("UPLOAD RECIEPT"),
                          color: Colors.deepOrangeAccent,
                          colorBrightness: Brightness.dark,
                          //set brghtness to dark, because deepOrangeAccent is darker coler
                          //so that its text color is light
                        )),
                      ))
                    ]),
                    new Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          );
  }
}
