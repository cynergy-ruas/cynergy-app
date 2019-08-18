import 'package:cynergy_app/models/events_model.dart';
import 'package:flutter/material.dart';

class EventsInfoPage extends StatelessWidget {
  static final routeName = "/eventsInfo";
  final Event event;

  EventsInfoPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: event.name,
      child: Material(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.31,
              child: Image.asset(
                "assets/images/events_placeholder.jpg",
                fit: BoxFit.none
              ),
            ),
            ListTile( 
              title: Text(event.name, style: TextStyle(fontSize: 20),),
              subtitle: Text(event.getFormattedDate()),
            )
          ],
        ),
      ),
    );
  }
}