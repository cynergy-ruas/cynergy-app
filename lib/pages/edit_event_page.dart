import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/event_form.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
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
        showStatusDialog(context, "Event Updated!", () async {
          await handler.updateEvent(
            date: date,
            time: time,
            duration: duration,
            title: title,
            type: "",
            venue: venue,
            by: by,
            description: description,
            links: links,
            documentID: event.documentID
          );
        });
      },
      onDelete: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("Confirmation", style: TextStyle(fontFamily: "Poppings"),),
              children: <Widget>[
                ListTile(
                  title: Text("Are you sure you want to delete the event?", style: TextStyle(fontFamily: "Poppins"),),                  
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text("Yes", style: TextStyle(fontFamily: "Poppins"),),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showStatusDialog(context, "Event Deleted!", () async {
                          await handler.deleteEvent(event);
                        });
                      }
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text("No", style: TextStyle(fontFamily: "Poppins"),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                )
              ], 
            );
          }
        );
      },
    );

  }
}