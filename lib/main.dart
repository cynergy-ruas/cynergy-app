import 'package:flutter/material.dart';
import 'pages/root/root_page.dart';
import 'utils/auth/login_auth.dart';
import 'utils/db/database.dart';
import 'pages/qrPage/qrCore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    FireStoreDB db = FireStoreDB();
    return new MaterialApp(
      title: "Cynergy",
      home: new RootPage(
        auth: Auth(),
        db: db
      ),
      debugShowCheckedModeBanner:false
    );
  }
}