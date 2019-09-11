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
        showStatusDialog(
          context: context, 
          message: "Event Updated!", 
          future: () async {
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
          }
        );
      },
      onDelete: () {
        showConfirmDialog(
          context: context,
          message: "Are you sure you want to delete the event?",
          onConfirm: () {
            Navigator.of(context).pop();
            showStatusDialog(
              context: context, 
              message: "Event Deleted!", 
              future: () async {
                await handler.deleteEvent(event);
              }
            );
          }
        );
      },
    );
  }
}