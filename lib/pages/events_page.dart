import 'package:cynergy_app/bloc/data_load_bloc.dart';
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
    /**
     * Initializes the widget. runs other initializing code.
     */

    super.initState();
    /// dispatching [DataLoadEvent] to load the data from firebase
    eventsBloc.dispatch(BeginDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Build the page.
     * 
     * Returns:
     *  Widget: The page contents.
     */
    
    return Center(
      child: BlocBuilder<DataLoadEvent, DataLoadState>(
        bloc: eventsBloc,
        builder: (context, state) {
          /// returning [CardView] that shows the events as a card.
          return CardView(
            events: (state is DataLoadComplete) ? state.data.reversed.toList() : null,
            itemCount: eventsBloc.handler.numOfEvents,
            onCardTap: (event) {},
            buildSkeleton: (state is DataLoadComplete) ? false : true,
          );
        },
      ),
    );
  }
}