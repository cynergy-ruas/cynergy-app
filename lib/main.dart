import 'package:flutter/material.dart';
import 'pages/root/root_page.dart';
import 'auth/login_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Cynergy",
      home: new RootPage(auth: Auth()),
      debugShowCheckedModeBanner:false
    );
  }
}
