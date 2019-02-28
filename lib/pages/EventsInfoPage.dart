import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:flutter/material.dart';

class EventsInfoPage extends StatelessWidget {

  final EventRepository event;

  EventsInfoPage({@required this.event}) :
      assert(event != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info"),
      ),
      body: Center(
        child: Text(event.eventName),
      ),
    );
  }
}
