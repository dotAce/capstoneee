import 'package:flutter/material.dart';
import 'Signup_Page.dart';

class typePage extends StatefulWidget {
  static String tag = 'typePage';
  _typePageState createState() => _typePageState();
}

class _typePageState extends State<typePage> {
  // String id;
  // final db = Firestore.instance;
  String value;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
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
                    child: GestureDetector(
                        child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 10.0),
                        child: new Container(
                          alignment: Alignment.center,
                          child: Material(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Text('Sign-Up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                )),
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
                          left: 40.0, right: 40.0, top: 40.0),
                      child: new Container(
                        child: Material(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          signupPage(type: "CONSUMER")));
                            },
                            minWidth: 30.0,
                            height: 60.0,
                            child: Text(
                              'Consumer',
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 40.0),
                      child: new Container(
                        child: Material(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          signupPage(type: "SELLER")));
                            },
                            minWidth: 30.0,
                            height: 60.0,
                            child: Text(
                              'Seller',
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
}
