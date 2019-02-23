import 'package:cynergy_app/services/Database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/repository/UserRepository.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';

import 'package:cynergy_app/pages/QrScannerPage.dart';

class HomePage extends StatefulWidget {

  final UserRepository userRepository;

  HomePage({@required this.userRepository}):
        assert(userRepository != null);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  UserRepository get _userRepository => widget.userRepository;
  Database db = Database();

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    List<Widget> drawerItems = (_userRepository.isCoordinator()) ?
        coordinatorDrawerItems() : memberDrawerItems();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authenticationBloc.dispatch(LoggedOut());
            },
          )
        ],
      ),
      body: Center(
        child: Text("Welcome"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                child: Text("Menu"),
              )
            ),
          ] + drawerItems,
        ),
      ),
    );
  }

  List<Widget> coordinatorDrawerItems(){
    return <Widget>[
      ListTile(
        title: Text("QR Code Scanner"),
        onTap: () {
          Navigator.of(context).pop(); // retracts drawer
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => QrScannerPage(db: db,)
          ));
        },
      ),
    ];
  }

  List<Widget> memberDrawerItems(){
    return <Widget>[

    ];
  }
}