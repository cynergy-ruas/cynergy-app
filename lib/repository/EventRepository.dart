import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class EventRepository{
  Timestamp date;
  Map<dynamic, dynamic> details;
  List<String> materials;
  List<String> videos;
  int duration;
  String eventName;
  String eventTopic;
  String type;
  int pos;  // like if its current event or past event or past past event

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
    return "event: "+eventName;
  }

  String getFormattedDate(){
    return DateFormat.yMMMMEEEEd().format(date.toDate());
  }
}