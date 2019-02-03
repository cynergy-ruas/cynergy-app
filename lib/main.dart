import 'package:flutter/material.dart';
import 'pages/root/root_page.dart';
import 'utils/auth/login_auth.dart';
import 'utils/db/database.dart';
import 'pages/qr/painter.dart';
import 'pages/qr/qrCore.dart';

void main() => runApp(MyApp());

/*class Aplo extends StatelessWidget{
@override 
 Widget build(BuildContext context){
 return new MaterialApp(
   title: "Qr page ",
   home: MainScreen(),
   debugShowCheckedModeBanner:false
     );
 }
}*/


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    FireStoreDB db = FireStoreDB();
    return new MaterialApp(
      theme: ThemeData(fontFamily:'Montserrat'),
      title: "Cynergy",
      home: new RootPage(
        auth: Auth(),
        db: db
      ),
      debugShowCheckedModeBanner:false
    );
  }
}
