import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  Timestamp date;
  Map<dynamic, dynamic> details;
  int duration;
  String name;
  String topic;
  String type;
  String documentID;

  Event({
    @required this.date,
    @required this.details,
    @required this.duration,
    @required this.name,
    @required this.topic,
    @required this.type,
  });

  String toString(){
    return "Event[Name: "+name+",Topic: "+topic+
        ",Date: "+getFormattedDate()+",Duration: "+duration.toString()+
        ".Description: "+details["description"]+",Type: "+type+"]";
  }

  String getFormattedDate(){
    return DateFormat.yMMMMEEEEd().format(date.toDate());
  }

  void setDocumentID(String documentID){
    this.documentID = documentID;
  }

}