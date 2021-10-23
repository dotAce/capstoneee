import 'package:gasapp/loading/loadingPage.dart';

import 'Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class signupPage extends StatefulWidget {
  static String tag = 'signupPage';
  _signupPageState createState() => _signupPageState(type);
  String type;
  signupPage({this.type});
}

class _signupPageState extends State<signupPage> {
  String type;
  String msg;
  String id;
  bool loading = false;
  _signupPageState(this.type);
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController contact_num = TextEditingController();
  TextEditingController password = TextEditingController();
  ScrollController _sc = ScrollController();
  @override
  void initState() {
    super.initState();
    if (type == "CONSUMER") {
      msg = "Succesfully Created";
    } else {
      msg = "Succesfully Created\n\nWait for your Verification";
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign Up'),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Center(
                child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 0.0, top: 20.0, bottom: 10),
                              child: new Container(
                                alignment: Alignment.center,
                                child: Material(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
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
                                  if (value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "First Name",
                                  icon: Icon(Icons.person,
                                      color: Colors.yellow[800]),
                                ),
                                controller: firstname,
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
                                  if (value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Last Name",
                                  icon: Icon(Icons.person,
                                      color: Colors.yellow[800]),
                                ),
                                controller: lastname,
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
                                  if (value.isEmpty) {
                                    return 'Enter your UserName';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Username",
                                  icon: Icon(Icons.supervised_user_circle,
                                      color: Colors.blue),
                                ),
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
                                  if (value.isEmpty) {
                                    return 'Enter your Contact Number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Contact Number",
                                  icon: Icon(Icons.phone, color: Colors.pink),
                                ),
                                controller: contact_num,
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
                                  icon: Icon(Icons.vpn_key, color: Colors.red),
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
                                left: 50.0, right: 50.0, top: 10.0),
                            child: new Container(
                              alignment: Alignment.center,
                              height: 70.0,
                              child: TextFormField(
                                  validator: (value) {
                                    if (value != password.text) {
                                      return 'Password not match';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Re-Password",
                                    icon:
                                        Icon(Icons.vpn_key, color: Colors.red),
                                  )),
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
                                      signup();
                                      setState(
                                        () => loading = true,
                                      );
                                    }
                                  },
                                  minWidth: 40.0,
                                  height: 30.0,
                                  child: Text(
                                    'Submit',
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
            )),
          );
  }

  void signup() async {
    var url = Uri.parse("https://gasapp123.000webhostapp.com/signup.php");

    var result = await http.post(url, body: {
      "fname": firstname.text,
      "lname": lastname.text,
      "contactnum": contact_num.text,
      "password": password.text,
      "username": username.text,
      "type": this.type,
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Username Exist!"),
            content: new Text("Try another Username"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
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
            // title: new Text("Username Exist!"),
            content: new Text(msg),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => loginPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }
}
