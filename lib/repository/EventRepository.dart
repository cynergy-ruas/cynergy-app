import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class EventRepository{
  Timestamp date;
  Map<dynamic, dynamic> details;
  List<String> materials;
  List<String> videos;
  int duration;
  String eventName;
  String eventTopic;
  String type;
  int pos;

  EventRepository({@required this.date,
                  @required this.details,
                  @required this.materials,
                  @required this.videos,
                  @required this.duration,
                  @required this.eventName,
                  @required this.eventTopic,
                  @required this.type,
                  @required this.pos});

  String toString(){
    return "date: "+date.toString();
  }
}