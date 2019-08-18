import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/pages/events_page.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  static final routeName = "/events";

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  DataLoadBloc eventsBloc;
  EventsHandler handler;

  @override
  void initState() {
    handler = EventsHandler();
    eventsBloc = DataLoadBloc(handler: handler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
    Events page.

    Returns:
      Scaffold: The home page contents.
    */

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Header(),
            SizedBox(height: 30,),
            Expanded(
              child: HomeTabView(
                length: 2,
                padding: 10,
                initialPage: 0,
                tabs: [
                  CustomTab(text: "Events",),
                  CustomTab(text: "Others",)
                ],
                pages: <Widget>[
                  EventsPage(eventsBloc: eventsBloc,),
                  Center(
                    child: Text("Others"),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        "Cynergy",
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w600
        )
      ),
    );
  }
}