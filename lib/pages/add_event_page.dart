import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/event_form.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatelessWidget {

  /// The [EventHandler] that will be used to add events
  final EventsHandler handler;

  AddEventPage({@required this.handler});

  @override
  Widget build(BuildContext context) {
    return EventForm(
      isNewEvent: true,
      onSaved: ({date, time, duration, title, venue, by, description, links}) {
        showStatusDialog(
          context: context, 
          message: "Event Uploaded!", 
          future: () async {
            await handler.addEvent(
              date: date,
              time: time,
              duration: duration,
              title: title,
              venue: venue,
              by: by,
              description: description,
              type: "",
              links: links);
          }
        );
      },
    );
  }
}