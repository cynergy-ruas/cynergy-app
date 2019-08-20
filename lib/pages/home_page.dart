import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/pages/events_page.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:flutter/material.dart';

import 'package:cynergy_app/theme_data.dart' as theme_data;


class HomePage extends StatefulWidget {
  static final routeName = "/events";

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  DataLoadBloc _eventsBloc;
  EventsHandler _handler;

  int _currentIndex = 0;

  @override
  void initState() {
    _handler = EventsHandler();
    _eventsBloc = DataLoadBloc(handler: _handler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
    Events page.

    Returns:
      Scaffold: The home page contents.
    */

    List pages = [
      buildHome(),
      EventsPage(eventsBloc: _eventsBloc,),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff373737),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Container()
          )
        ],
        selectedIconTheme: IconThemeData(color: theme_data.purple),
        unselectedIconTheme: IconThemeData(color: Color(0xff9f9f9f)),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }

  Widget buildHome() {
    /**
     * Builds the Home page contents.
     * 
     * Returns
     *  Widget: The home page contents.
     */
    
    return Center(
      child: Text("HomePage", style: TextStyle(color: Colors.white)),
    );
  }
}