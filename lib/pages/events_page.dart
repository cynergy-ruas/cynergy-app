import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/pages/events_info_page.dart';
import 'package:cynergy_app/widgets/cards_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {

  final DataLoadBloc eventsBloc;

  EventsPage({@required this.eventsBloc});

  @override
  State<StatefulWidget> createState() => _EventsPageState();
  
}

class _EventsPageState extends State<EventsPage> {

  DataLoadBloc get eventsBloc => widget.eventsBloc;

  @override
  void initState() {
    super.initState();
    eventsBloc.dispatch(BeginDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<DataLoadEvent, DataLoadState>(
        bloc: eventsBloc,
        builder: (context, state) {
          return CardView(
            events: (state is DataLoadComplete) ? state.data.reversed.toList() : null,
            itemCount: eventsBloc.handler.numOfEvents,
            onCardTap: (state is DataLoadComplete) 
              ? (event) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, anim, secondaryAnim) => EventsInfoPage(event: event,),
                    transitionDuration: Duration(milliseconds: 500) 
                  ));
                }
              : (event) {},
            buildSkeleton: (state is DataLoadComplete) ? false : true,
          );
        }
      )
    );
  }
}