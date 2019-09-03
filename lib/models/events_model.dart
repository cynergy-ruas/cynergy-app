import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  Timestamp date;
  Map<dynamic, dynamic> info;
  int duration;
  String name;
  String topic;
  String type;
  String documentID;
  String venue;
  String by;

  Event({
    @required this.date,
    @required this.info,
    @required this.duration,
    @required this.name,
    @required this.topic,
    @required this.type,
    @required this.venue,
    @required this.by
  });

  Event.fromBareBones({
    @required this.date,
    @required this.duration,
    @required this.name,
    @required this.topic,
    @required this.type,
    @required this.venue,
    @required this.by,
    @required String description,
    @required List links
  }) {
    this.info = _buildDetailsField(description: description, links: links);
  }

  void addLink(String title, String url) {
    /**
     * Adds a link to the [info["materials"]] field.
     * 
     * Args:
     *  title (String): The title of the link
     *  url (String): The url of the link
     * 
     * Returns:
     *  void
     */

    (info["materials"]["links"] as List).add({"title": title, "url": url});
  }

  List getLinks() {
    /**
     * Returns the links present in materials.
     * 
     * Returns:
     *  List: The links.
     */

    return info["materials"]["links"];
  }

  Map<String, String> getLink(int index) {
    /**
     * Gets the link at the specified index.
     * 
     * Args:
     *  index (int): The link at the index.
     * 
     * Returns:
     *  Map<String, String>: The link.
     */

    return (info["materials"]["links"] as List)[index];
  }

  Map<dynamic, dynamic> _buildDetailsField({@required String description, @required List links}) {
    /**
     * Build the details field for the firestore document.
     * 
     * Args:
     *  description (String): The description of the event
     *  links (List): The list containing links
     * 
     * Returns:
     *  Map<dynamic, dynamic> : The details field. 
     */

    return {
      "description": description,
      "materials": {
        "links": links
      }
    };

  }

  String toString(){
    return "Event[Name: "+name+",Topic: "+topic+
        ",Date: "+getLongDate()+",Duration: "+duration.toString()+
        ".Description: "+info["description"]+",Type: "+type+"]";
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

  String getTime() {
    /**
     * Formats the [TimeStamp] and returns the time in the format:
     * {Hour}:{Minute} {AM/PM}
     * 
     * Returns:
     *  String: The time.
     */

    return DateFormat.jm().format(date.toDate());
  }

  String get description {
    /**
     * Extracts the description from the [details]
     * 
     * Returns: 
     *  String: The description. 
     */

    return info["description"];
  }

  void setDocumentID(String documentID){
    /**
     * Sets the document id.
     */
    
    this.documentID = documentID;
  }
}

class EventPool {
  static List<Event> events;

  static setEvents(List<Event> e) {
    events = e;
  } 

  static int getIndexOfFirstPastEvent() {
    for (int i = 0;i<events.length;i++) {
      if (DateTime.now().difference(events[i].date.toDate()) > Duration(seconds: 0))
        return i;
    }
    return 0;
  }
}