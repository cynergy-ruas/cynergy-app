import 'package:Cynergy/models/events_model.dart';
import 'package:flutter/material.dart';

class EventsInfoPage extends StatelessWidget {
  static final routeName = "/eventsInfo";
  final Event event;

  EventsInfoPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Events info"),
      )
    );
  }
}