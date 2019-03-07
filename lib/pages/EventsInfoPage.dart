import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:flutter/material.dart';

class EventsInfoPage extends StatelessWidget {

  final EventRepository event;

  EventsInfoPage({@required this.event}) :
      assert(event != null);

  @override
  Widget build(BuildContext context) {
    final topContent = Container(
      padding: EdgeInsets.only(top: 40, bottom: 60),
      child:Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30
                  ),
                  onTap: ()=>Navigator.pop(context),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text(
              event.eventName,
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            leading: Container(
              padding: EdgeInsets.only(left: 10),
              child:Icon(
                Icons.event,
                size: 30,
                color: Colors.white
              ),
              decoration: BoxDecoration(
                border: Border(
                  right: new BorderSide(width: 1.0, color: Colors.white)
                )
              ),
            ),
            subtitle: Text(
              event.type+",\n"+event.getFormattedDate(),
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/events_placeholder.jpg"),
          fit: BoxFit.fill,
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.hardLight)
        )
      ),
    );

    Widget bottomContent = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          ListTile(
            title: Icon(
              Icons.info,
              size: 30
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                event.details["description"],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2,
            child: Divider(
              color: Colors.black54,
              height: 30,
            ),
          ),
          SizedBox(height: 30,),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.av_timer,
                  size: 30
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    event.duration.toString()+" minutes",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ]
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topContent,
            bottomContent
          ],
        ),
      )
    );
  }
}
