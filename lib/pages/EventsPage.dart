import 'package:cynergy_app/bloc/EventsLoadBloc.dart';
import 'package:cynergy_app/events/EventsLoadEvents.dart';
import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:cynergy_app/states/EventsLoadStates.dart';
import 'package:cynergy_app/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:cynergy_app/widgets/EventCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {

  final EventsLoadBloc eventsLoadBloc;

  EventsPage({@required this.eventsLoadBloc}):
      assert(eventsLoadBloc != null);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  EventsLoadBloc get _eventsLoadBloc => widget.eventsLoadBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events")
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
                  Text("Past, Present and Future",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ] + ((state is EventsLoadDone) ? generateCards(state.events) : [LoadingIndicator()]),
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  List<Widget> generateCards(List<EventRepository> events){
    List<Widget> w = [
      SizedBox(height: 40),
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
