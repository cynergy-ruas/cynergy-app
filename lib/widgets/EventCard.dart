import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:flutter/material.dart';
import 'package:cynergy_app/pages/EventsInfoPage.dart';

class EventCard extends StatelessWidget {

  final EventRepository event;

  EventCard({@required this.event}):
      assert(event != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              decoration:BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/events_placeholder.jpg'),
                  fit: BoxFit.cover
                )
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black)
                  )
                ),
                child: Icon(Icons.av_timer, color: Colors.black),
              ),
              title: Text(
                event.eventName,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text(" Intermediate", style: TextStyle(color: Colors.black))
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => EventsInfoPage()
                  ));
                },
              )
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(event.details["description"])
            )
          ],
        )
      )
    );
  }
}
