import 'package:bloc/bloc.dart';
import 'package:cynergy_app/bloc/bloc_delegate.dart';
import 'package:cynergy_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(CynergyApp()));

class CynergyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    BlocSupervisor().delegate = SimpleBlocDelegate();
    return MaterialApp(
      title: 'Cynergy',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

