import 'package:bloc/bloc.dart';
import 'package:Cynergy/bloc/bloc_delegate.dart';
import 'package:Cynergy/pages/login_page.dart';
import 'package:Cynergy/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(CynergyApp()));

class CynergyApp extends StatelessWidget {
  /// This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    BlocSupervisor().delegate = SimpleBlocDelegate();
    return MaterialApp(
      title: 'Cynergy',
      home: LoginPage(),
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

