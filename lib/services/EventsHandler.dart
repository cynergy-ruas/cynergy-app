import 'package:meta/meta.dart';

import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:cynergy_app/services/Database.dart';

class EventsHandler{
  Database db;

  EventsHandler({@required this.db}):
      assert(db != null);

  Future<List<EventRepository>> getEvents() async{
    int numOfEvents = 3;
    List<Map<String, dynamic>> data = await db.getRecentEvents(numOfEvents);
    List<EventRepository> events = [];

    for(int i=0;i<numOfEvents;i++){
      events.add(EventRepository(date: data[i]["date"],
          details: data[i]["details"],
          duration: data[i]["duration"],
          eventName: data[i]["eventName"],
          eventTopic: data[i]["eventTopic"],
          type: data[i]["type"],));
    }

    return events;
  }

  Future<bool> uploadEvent({@required EventRepository event}) async{
    return db.uploadEvent(event: event);
  }
}