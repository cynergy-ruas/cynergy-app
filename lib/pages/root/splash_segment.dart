import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new SizedBox(
          height: 50,
          width: 50,
          child: new CircularProgressIndicator(
            value: null,
            strokeWidth: 7.0,
          )
        )
      ),
    );
  }
}