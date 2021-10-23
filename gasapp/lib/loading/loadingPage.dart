import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.blue,
        ),
      ),
    );
  }
}
