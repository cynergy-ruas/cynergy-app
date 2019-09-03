import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/event_form.dart';
import 'package:flutter/material.dart';

class EventsEditPage extends StatelessWidget {
  
  final Event event;
  final EventsHandler handler;

  EventsEditPage({@required this.event, this.handler});

  @override
  Widget build(BuildContext context) {
    return EventForm(
      event: event,
      isNewEvent: false,
      onSaved: ({date, time, duration, title, venue, by, description, links}) {

      },
      onDelete: () {
        _showDialog(context, handler.deleteEvent, event);
      },
    );

  }

  void _showDialog(BuildContext context, dynamic future, dynamic args) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          children: <Widget> [
            FutureBuilder(
              future: future(args),
              builder: (context, snapshot) {
                Widget body;
                if (snapshot.connectionState == ConnectionState.done) {
                  body = Center(
                    child: Text("Event deleted!", style: TextStyle(fontFamily: "Poppins")),
                  );
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    Navigator.of(context).popUntil((route) {
                      return route.isFirst;
                    });
                  });
                } else {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SizedBox(
                  height: 150,
                  width: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 150),
                        child: body,
                      )
                    ],
                  ),
                );
              },
            ),
          ]
        );
      }
    );
  }
}