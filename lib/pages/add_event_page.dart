import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/event_form.dart';
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
        _showDialog(context, date, time, duration, title, venue, by, description, links);
      },
    );
  }

  void _showDialog(BuildContext context, DateTime date, DateTime time, int duration, String title, String venue, String by, String description, List links) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          children: <Widget> [
            FutureBuilder(
              future: handler.addEvent(date: date, time: time, duration: duration, title: title, venue: venue, by: by, description: description, type: "", links: links),
              builder: (context, snapshot) {
                Widget body;
                if (snapshot.connectionState == ConnectionState.done) {
                  body = Center(
                    child: Text("Event uploaded!", style: TextStyle(fontFamily: "Poppins")),
                  );

                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
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

  Future<int> _onDone() async {
    await Future.delayed(Duration(seconds: 2));
    return 100;
  }
}