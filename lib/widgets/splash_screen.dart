import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Welcome",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}