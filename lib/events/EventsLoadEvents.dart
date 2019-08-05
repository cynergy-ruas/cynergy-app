import 'package:equatable/equatable.dart';

class EventsLoadEvent extends Equatable{
  EventsLoadEvent([List props = const []]): super(props);
}

class EventsLoadStart extends EventsLoadEvent{
  @override
  String toString() => "EventsLoadStart";
}