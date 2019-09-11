import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/services/database.dart';
import 'package:meta/meta.dart';

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
      Event event = Event(
        date: data[i]["date"],
        by: data[i]["by"],
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

  Future<void> addEvent({
    @required DateTime date,
    @required DateTime time,
    @required int duration,
    @required String title,
    @required String type,
    @required String venue,
    @required String by,
    @required String description,
    @required List links
  }) async {
    DateTime parsedDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second
    );

    Event event = Event.fromBareBones(
      date: Timestamp.fromDate(parsedDate),
      duration: duration,
      name: title,
      topic: title,
      type: type,
      venue: venue,
      by: by,
      description: description,
      links: links
    );

    Database db = await Database.getInstance();
    await db.uploadEvent(event: event);
  }

  Future<void> updateEvent({
    @required DateTime date,
    @required DateTime time,
    @required int duration,
    @required String title,
    @required String type,
    @required String venue,
    @required String by,
    @required String description,
    @required List links,
    @required String documentID
  }) async {
    DateTime parsedDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second
    );

    Event event = Event.fromBareBones(
      date: Timestamp.fromDate(parsedDate),
      duration: duration,
      name: title,
      topic: title,
      type: type,
      venue: venue,
      by: by,
      description: description,
      links: links
    );
    event.setDocumentID(documentID);

    Database db = await Database.getInstance();
    await db.updateEvent(event: event);
  }

  Future<void> deleteEvent(Event event) async {
    Database db = await Database.getInstance();
    await db.deleteEvent(event: event);
  }
}