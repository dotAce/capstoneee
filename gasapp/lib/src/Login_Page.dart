import 'package:flutter/material.dart';
import 'package:gasapp/loading/loadingPage.dart';
import 'package:gasapp/src/consumer_map.dart';
import 'package:http/http.dart' as http;
import 'Adminhomepage.dart';
import 'Home_Pages.dart';
import 'type.dart';

// ignore: camel_case_types
class loginPage extends StatefulWidget {
  static String tag = 'loginPage';
  _loginPageState createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {
  // String id;
  // final db = Firestore.instance;
  String value;
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool loading = false;

  String status;

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Image.asset('img/assets/logo.png'),
                        ),
                        new Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50.0, top: 10.0),
                                child: new Container(
                                  alignment: Alignment.center,
                                  height: 70.0,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter your Username';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Username",
                                      icon: Icon(
                                        Icons.supervised_user_circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      value = text;
                                    },
                                    controller: username,
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
                                    left: 50.0, right: 50.0, top: 10.0),
                                child: new Container(
                                  alignment: Alignment.center,
                                  height: 70.0,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.length < 8) {
                                        if (value.isEmpty) {
                                          return 'Password is empty';
                                        } else {
                                          return 'Atleast 8 character';
                                        }
                                      }

                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Password",
                                      icon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.red,
                                      ),
                                    ),
                                    controller: password,
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
                                  child: Material(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: Colors.blue,
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          login();
                                          setState(
                                            () => loading = true,
                                          );
                                        }
                                      },
                                      minWidth: 40.0,
                                      height: 30.0,
                                      child: Text(
                                        'Login',
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
                        new Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => typePage()));
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 0.0, top: 10.0),
                                      child: new Container(
                                        alignment: Alignment.center,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          child: Text(
                                            'SignUp',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
  }

  void login() async {
    var url = Uri.parse("https://gasapp123.000webhostapp.com/login.php");

    var result = await http.post(url, body: {
      "password": password.text,
      "username": username.text,
    });

    var myInt = int.parse(result.body);
    print(myInt);

    if (myInt == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Consumer_map(consumer_username: username.text)));
    } else if (myInt == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => homepages(value: username.text)));
    } else if (myInt == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => adminhomepages(
                    value: username.text,
                  )));
    } else if (myInt == 5) {
      setState(
        () => loading = false,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Username Exist!"),
            content: new Text("Account Not Verify"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new loginPage()));
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(
        () => loading = false,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Username Exist!"),
            content: new Text("Invalid Account"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new loginPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }
}
