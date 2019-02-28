import 'package:cynergy_app/bloc/EventsLoadBloc.dart';
import 'package:cynergy_app/events/EventsLoadEvents.dart';
import 'package:cynergy_app/services/Database.dart';
import 'package:cynergy_app/services/EventsHandler.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/repository/UserRepository.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';

import 'package:cynergy_app/pages/QrScannerPage.dart';
import 'package:cynergy_app/pages/EventsPage.dart';
import 'package:cynergy_app/pages/AnnouncementsPage.dart';
import 'package:cynergy_app/pages/LeaderboardPage.dart';
import 'package:cynergy_app/pages/AboutPage.dart';


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

  EventsLoadBloc eventsBloc;
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    eventsBloc = EventsLoadBloc(handler: EventsHandler(db: db));

    List<Widget> drawerItems = (_userRepository.isCoordinator()) ?
        normalDrawerItems() + coordinatorDrawerItems() : normalDrawerItems();

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
      _createDrawerItem(
          icon: Icon(Icons.filter_center_focus),
          title: "QR Code Scanner",
          page: QrScannerPage(db: db)
      ),
    ];
  }

  List<Widget> normalDrawerItems(){
    return <Widget>[
      _createDrawerItem(
        icon: Icon(Icons.announcement),
        title: "Announcements",
        page: AnnouncementsPage()
      ),
      _createDrawerItem(
        icon: Icon(Icons.poll),
        title: "Leaderboard",
        page: LeaderboardPage()
      ),
      _createDrawerItem(
        icon: Icon(Icons.event),
        title: "Events",
        page: EventsPage(eventsLoadBloc: eventsBloc,),
        callback: ()=>eventsBloc.dispatch(EventsLoadStart())
      ),
      _createDrawerItem(
        icon: Icon(Icons.account_balance),
        title: "About",
        page: AboutPage()
      ),
    ];
  }

  ListTile _createDrawerItem({@required Icon icon, @required String title, @required Widget page, VoidCallback callback}){
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop(); // retracts drawer
          if (callback != null) callback();
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => page,
          ));
        }
    );
  }
}