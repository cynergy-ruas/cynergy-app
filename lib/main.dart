import 'package:flutter/material.dart';
import 'login/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "login page",
      home: new LoginPage(),debugShowCheckedModeBanner:false,
    );
  }
}