import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/models/events_model.dart';
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
          Widget body;
          if (state is DataLoadComplete) {
            /// returning [CardView] that shows the events as a card.
            body = CardView(
              events: EventPool.events,
              itemCount: eventsBloc.handler.numOfEvents,
              shouldAnimate: true,
            );
          }

          else
            /// returning [CircularProgressIndicator] if data is not loaded yet
            body = CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            );

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: body,
          );
        },
      ),
    );
  }
}