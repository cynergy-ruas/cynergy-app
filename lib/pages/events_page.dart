import 'package:cynergy_app/bloc/data_load_bloc.dart';
import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/models/user_model.dart';
import 'package:cynergy_app/pages/add_event_page.dart';
import 'package:cynergy_app/services/events_handler.dart';
import 'package:cynergy_app/widgets/cards_view.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {

  final DataLoadBloc eventsBloc;
  final EventsHandler handler;

  EventsPage({@required this.eventsBloc, @required this.handler});

  @override
  State<StatefulWidget> createState() => _EventsPageState();
  
}

class _EventsPageState extends State<EventsPage> {

  DataLoadBloc get eventsBloc => widget.eventsBloc;
  EventsHandler get handler => widget.handler;

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
    
    return BlocBuilder<DataLoadEvent, DataLoadState> (
      bloc: eventsBloc,
      builder: (context, state) {
        Widget body;
        Widget floatingActionButton;
        if (state is DataLoadComplete) {
          /// returning [CardView] that shows the events as a card.
          body = InheritedEventHandler(
            handler: handler,
            child: CardView(
              events: EventPool.events,
              itemCount: eventsBloc.handler.numOfEvents,
              shouldAnimate: true,
            ),
          );
          floatingActionButton = (User.getInstance().getClearanceLevel() > 1)
            ? FloatingActionButton(
                mini: true,
                child: Icon(Icons.add),
                onPressed: () {
                  // instantiate [AddEventPage] here. DO NOT instantiate it in 
                  // the [pageBuilder] argument in [PageRouteBuilder]. refer
                  // https://github.com/flutter/flutter/issues/37878 for more details
                  Widget page = AddEventPage(handler: handler,);
                  
                  Navigator.of(context).push(SlideFromDownPageRouteBuilder(page: page));
                },
              )
            : null;
        }

        else
          /// returning [CircularProgressIndicator] if data is not loaded yet
          body = CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          );

        return Scaffold(
          body: Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: body,
            ),
          ),
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}

class InheritedEventHandler extends InheritedWidget {

  final EventsHandler handler;

  InheritedEventHandler({this.handler, child}) : super(child: child);

  static InheritedEventHandler of(BuildContext context) => 
    context.inheritFromWidgetOfExactType(InheritedEventHandler);

  @override
  bool updateShouldNotify(InheritedEventHandler oldWidget) => handler != oldWidget.handler;
}