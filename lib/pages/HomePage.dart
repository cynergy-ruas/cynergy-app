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

const MaterialColor color=const MaterialColor(0xFF001636, const <int,Color>{50: const Color(0xFF030e1d)});

final ThemeData themeData=new ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme(primary: color,secondary: color[50],
          onPrimary:Colors.white,onSecondary: Colors.grey,
          brightness: Brightness.dark,
          primaryVariant: color,
          secondaryVariant: color[50],  //TODO: decide better theming
          surface: Colors.white,background: color,
          error: Colors.red,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.red),
      fontFamily: 'Montserrat',
  //color: color,
      textTheme: TextTheme(),
  //primaryTextTheme: TextTheme(title: TextStyle(color: const Color(0xFFde3f0f),)),
      appBarTheme: AppBarTheme(color: const Color(0xFF1C2331),
      textTheme: TextTheme(title:(TextStyle(color:const Color(0xFFde3f0f),fontSize: 21))),
      ),
      accentColor: const Color(0xFF030e1d)
);
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

    return Theme(
      data: themeData,
      child:Scaffold(      
      appBar: AppBar(        
        title: Text('Home'),
        /*  actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authenticationBloc.dispatch(LoggedOut());
              },
            )
          ],*/
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                   image:DecorationImage(
                     image:NetworkImage("https://cynergy-ruas.github.io/assets/logos/cynergy-logo.png"),             
                   )
                  ),
                ),
              )
            ),
          ] + drawerItems + logoutItem(),
        ),
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
      Divider(),
    ];
  }
  List<Widget> logoutItem(){
    return <Widget>[
       ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            
            final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);
                authenticationBloc.dispatch(LoggedOut());
          }
          
       )
    ];
  }

  List<Widget> normalDrawerItems(){
    return <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text("AccountName"),
        accountEmail: Text("AccountEmail"),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage("https://secure.i.telegraph.co.uk/multimedia/archive/03290/kitten_potd_3290498k.jpg")
          )
        ),
        currentAccountPicture: GestureDetector(
          onTap: ()=> print("idk something should happen maybe"),
          child: (
            CircleAvatar(
              backgroundImage: NetworkImage("https://cynergy-ruas.github.io/assets/default-avatar.jpg"),
            )
          ),
        )
      ),
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
        page: EventsPage(eventsLoadBloc: eventsBloc, userIsCoordinator: _userRepository.isCoordinator(),),
        callback: ()=>eventsBloc.dispatch(EventsLoadStart())
      ),
      _createDrawerItem(
        icon: Icon(Icons.account_balance),
        title: "About",
        page: AboutPage()
      ),
      Divider(),
      
    ];
  }

  ListTile _createDrawerItem({@required Icon icon, @required String title, @required Widget page, VoidCallback callback}){
    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop(); // retracts drawer
          if (callback != null)
            callback();

          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => page,
          ));
        }
    );
  }
}