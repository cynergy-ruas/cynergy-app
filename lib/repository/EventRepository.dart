import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class EventRepository{
  Timestamp date;
  Map<dynamic, dynamic> details;
  int duration;
  String eventName;
  String eventTopic;
  String type;
  String documentID;

  EventRepository({@required this.date,
                  @required this.details,
                  @required this.duration,
                  @required this.eventName,
                  @required this.eventTopic,
                  @required this.type,});

  String toString(){
    return "Event[Name: "+eventName+",Topic: "+eventTopic+
        ",Date: "+getFormattedDate()+",Duration: "+duration.toString()+
        ".Description: "+details["description"]+",Type: "+type+"]";
  }

  String getFormattedDate(){
    return DateFormat.yMMMMEEEEd().format(date.toDate());
  }

  static Map<dynamic, dynamic> createDetails({@required String description,
    String logs = "",
    List<String> materials = const [""],
    List<String> videos = const [""]}
  ){
    Map<dynamic, dynamic> map = Map();
    map["description"] = description;
    map["logs"] = logs;
    map["materials"] = materials;
    map["videos"] = videos;

    return map;
  }

  void setDocumentID(String documentID){
    this.documentID = documentID;
  }

}