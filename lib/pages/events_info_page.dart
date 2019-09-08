import 'package:cynergy_app/models/events_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsInfoPage extends StatelessWidget {
  final Event event;

  EventsInfoPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/events_placeholder.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.srcOver)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            _backButton(context),
            SizedBox(height: 30,),
            _header(),
            SizedBox(height: 20,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: _content(context),
              ),
            )
          ],
        )
      )
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 10, top: 3, bottom: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.arrow_back_ios, color: Colors.black,),
            SizedBox(width: 10,),
            Text("Back", style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text(
              event.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _content(BuildContext context) {
    List links = event.getLinks();

    return Container(
      padding: EdgeInsets.all(20),
      color: Theme.of(context).accentColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            // title
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "By: " + event.by, 
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),

            // description
            Text(
              event.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                height: 1.25
              ),
            ),
            SizedBox(height: 30,),

            // date
            Text(
              "Date: " + event.getLongDate(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10,),

            // time
            Text(
              "Starting at: " + DateFormat("h:mm a").format(event.date.toDate()),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10,),

            // Duration
            Text(
              "Duration: ~ " + (event.duration / 60).toString() + " hrs",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10,),

            // venue
            Text(
              "Venue: " + event.venue,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10,),

            // links
            Text(
              "Resources: ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
          ] + ((links.length == 0)
          ? [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "No resources provided.",
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
            ]
          : [
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shrinkWrap: true,
                itemCount: links.length,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: _Link(link: links[position]),
                  );
                },
              )
            ] 
          ),
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget{

  final Map link;

  _Link({@required this.link});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "- ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )
          ),
          TextSpan(
            text: link["title"],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launch(link["url"])
          )
        ]
      ),
    );
  }
}