import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:cynergy_app/events/EventsLoadEvents.dart';
import 'package:cynergy_app/states/EventsLoadStates.dart';
import 'package:cynergy_app/services/EventsHandler.dart';

class EventsLoadBloc extends Bloc<EventsLoadEvent, EventsLoadState>{

  EventsHandler handler;

  EventsLoadBloc({@required this.handler}):
      assert(handler != null);

  @override
  EventsLoadState get initialState => EventsLoadInitial();

  @override
  Stream<EventsLoadState> mapEventToState(EventsLoadState currentState, EventsLoadEvent event) async*{
    if (event is EventsLoadStart){
      yield EventsLoadLoading();
      try {
        List<EventRepository> events = await handler.getEvents();
        yield EventsLoadDone(events: events);
      }
      catch(e){
        print(e);
        yield EventsLoadFailure(error: e.toString());
      }
    }
  }

}