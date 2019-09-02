import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/services/database.dart';

class EventsHandler {
  final int numOfEvents = 4;

  Future<List<Event>> loadData() async {
    /**
     * Gets the events from the database.
     * 
     * Returns:
     *  List<Event>: List of [Event] objects;
     */

    Database db = await Database.getInstance();
    List<Map<String, dynamic>> data = await db.getRecentEvents(count: numOfEvents);

    List<Event> events = [];
    for (int i = 0;i < numOfEvents; i++) {
      Event event = Event(date: data[i]["date"],
        info: data[i]["details"],
        duration: data[i]["duration"],
        name: data[i]["eventName"],
        topic: data[i]["eventTopic"],
        type: data[i]["type"],
        venue: data[i]["venue"]);

      event.setDocumentID(data[i]['docRef']);
      events.add(event);
    }

    return events;
  }
}