
import 'package:cynergy_app/bloc/EventsLoadBloc.dart';

import 'package:cynergy_app/events/EventsLoadEvents.dart';
import 'package:cynergy_app/pages/AddEventPage.dart';
import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:cynergy_app/states/EventsLoadStates.dart';
import 'package:cynergy_app/pages/HomePage.dart';
import 'package:cynergy_app/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:cynergy_app/widgets/EventCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {

  final EventsLoadBloc eventsLoadBloc;
  final bool userIsCoordinator;

  EventsPage({@required this.eventsLoadBloc, @required this.userIsCoordinator}):
      assert(eventsLoadBloc != null);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  EventsLoadBloc get _eventsLoadBloc => widget.eventsLoadBloc;
  bool get _userIsCoordinator => widget.userIsCoordinator;

  @override
  Widget build(BuildContext context) {

    List<Widget> actions = (_userIsCoordinator) ? [
      IconButton(
        icon: Icon(Icons.add),
        iconSize: 30,
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context)=>AddEventPage()
        )),
      )
    ] : [];

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Events"),
          actions: actions,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: BlocBuilder<EventsLoadEvent, EventsLoadState>(
              bloc: _eventsLoadBloc,
              builder: (BuildContext context, EventsLoadState state){
                if (state is EventsLoadFailure){
                  _onWidgetDidBuild(() => Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Try again'),
                      backgroundColor: Colors.red,
                    ),
                  ));
                  return Center(
                    child: Icon(
                        Icons.error,
                        size: 40
                    ),
                  );
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                      title:Text("Past, Present and Future",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: const Color(0xFFFDC830)),
                      ),
                    )
                  ] + ((state is EventsLoadDone) ? generateCards(state.events) : [LoadingIndicator()]),
                );
              },
            ),
          ),
        ),

      ),
    );
  }

  List<Widget> generateCards(List<EventRepository> events){
    List<Widget> w = [
      SizedBox(height: 20),
    ];

    for(EventRepository event in events){
      w.add(SizedBox(height: 10,));
      w.add(EventCard(event: event,));
    }

    return w;
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  void dispose(){
    _eventsLoadBloc.dispose();
    super.dispose();
  }
}
