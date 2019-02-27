import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class EventsLoadState extends Equatable{
  EventsLoadState([List props = const []]): super(props);
}

class EventsLoadInitial extends EventsLoadState{
  @override
  String toString() => "EventsLoadInitial";
}

class EventsLoadLoading extends EventsLoadState{
  @override
  String toString() => "EventsLoadLoading";
}

class EventsLoadDone extends EventsLoadState{
  List<EventRepository> events;

  EventsLoadDone({@required this.events}):
      assert(events != null),
      super([events]);

  @override
  String toString() => "EventsLoadDone";
}

class EventsLoadFailure extends EventsLoadState{
  final String error;

  EventsLoadFailure({@required this.error}):
      assert(error != null),
      super([error]);

  @override
  String toString() => "EventsLoadFailure { error: $error }";
}