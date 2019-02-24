import 'package:flutter/material.dart';
import 'package:cynergy_app/widgets/EventCard.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events")
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Text("The Past, Present and Future",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

              ),
              SizedBox(height: 40),
              EventCard(),
              SizedBox(height: 10),
              EventCard(),
              SizedBox(height: 10),
              EventCard(),
              SizedBox(height: 10),
            ],
          )
        )
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
