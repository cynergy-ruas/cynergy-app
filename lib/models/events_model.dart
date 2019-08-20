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
        ",Date: "+getLongDate()+",Duration: "+duration.toString()+
        ".Description: "+details["description"]+",Type: "+type+"]";
  }

  String getLongDate(){
    /**
     * Formats the date.
     * 
     * Returns:
     *  String: The formated date
     */

    return DateFormat.yMMMMEEEEd().format(date.toDate());
  }

  String getShortDate() {
    /**
     * Formats the date. example: 26th March, 2019
     * 
     * Returns:
     *  String: The formated date.
     */

    DateTime _date = this.date.toDate();
    
    String day = DateFormat.d().format(_date);
    String daySuffix = "th";
    if (day.endsWith("1")) daySuffix = "st";
    else if (day.endsWith("2")) daySuffix = "nd";
    else if (day.endsWith("3")) daySuffix = "rd";

    return day + daySuffix + " " + 
           DateFormat.MMMM().format(_date) + ", " +
           DateFormat.y().format(_date); 
  }

  String getDescription() {
    /**
     * Extracts the description from the [details]
     * 
     * Returns: 
     *  String: The description. 
     */

    return details["description"];
  }

  void setDocumentID(String documentID){
    /**
     * Sets the document id.
     */
    
    this.documentID = documentID;
  }

}