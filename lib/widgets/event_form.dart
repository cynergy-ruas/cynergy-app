import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/models/user_model.dart';
import 'package:cynergy_app/widgets/add_resources_list.dart';
import 'package:flutter/material.dart';

import 'misc_widgets.dart';

typedef void OnSavedCallback({@required DateTime date, @required DateTime time, @required int duration, @required String title, @required String venue, @required String by, @required String description, @required List links});

class EventForm extends StatefulWidget {
  /// Widget that represents an [Event] as an interactable interface.
  
  /// the event
  final Event event;

  /// callback executed when form is saved
  final OnSavedCallback onSaved;
  

  /// specifies whether the event being represented is a 
  /// new event or not. This is needed for the "Delete Event"
  /// button.
  final bool isNewEvent;


  /// called when delete event button is clicked
  final VoidCallback onDelete;

  EventForm({this.event, @required this.isNewEvent, @required this.onSaved, this.onDelete}) :
    assert((isNewEvent && onDelete == null) || (! isNewEvent && onDelete != null));

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  // getting the parameters from widget
  Event get event => widget.event;

  bool get isNewEvent => widget.isNewEvent;

  VoidCallback get onDelete => widget.onDelete;

  OnSavedCallback get onSaved => widget.onSaved;

  /// variable to access the title field
  String _title;

  /// variable to access the by field
  String _by;

  /// variable to access the duration field
  int _duration;
  
  /// variable to access the venue field
  String _venue;
  
  /// variable to access the description field
  String _description;

  /// [DateTime] object to access the date field
  DateTime _date;

  /// [DateTime] object to access the time field
  DateTime _time;

  // the data structure for the links
  List _links;

  // the key for the form
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _links = List();
    if (event != null)
      _links.addAll(event.getLinks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // The back button
            BackButtonNoBackground(),

            // The fields
            SizedBox(height: 10,),
            Expanded(
              child: _form(context, _links),
            ),

            // The footer buttons
            SizedBox(height: 20,),
            _footer(),
          ],
        ),
      )
    );
  }

  Widget _form(BuildContext context, List links) {
    /**
     * Build the form.
     * 
     * Args:
     *  context (BuildContext): The current [BuildContext]
     *  links (list): The links to be placed under the "resources" section.
     * 
     * Returns:
     *  Widget: The form.
     */

    DateTime parsedDate = event?.date?.toDate();
    DateTime day;
    DateTime time;

    if (parsedDate != null) {
      day = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      time = parsedDate;
    }

    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          // for title
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Title", style: _textFieldTitleTextStyle(),),
                SizedBox(height: 20,),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                  validator: (value) => _validator(value, "Title"),
                  onSaved: (value) => _title = value,
                  initialValue: event?.topic,
                ),
                SizedBox(height: 20,),

                // for by field
                Text("By", style: _textFieldTitleTextStyle(),),
                SizedBox(height: 20,),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                  validator: (value) => _validator(value, "By"),
                  onSaved: (value) => _by = value,
                  initialValue: event?.by,
                ),

                // for date picker and time picker titles
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Date", style: _textFieldTitleTextStyle(),),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      child: Text("Time", style: _textFieldTitleTextStyle(),),
                    )
                  ],
                ),

                // for date and time picker
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DatePickerField(
                        initialValue: day,
                        onSaved: (value) => _date = value,
                        validator: (value) {
                          if (value == null)
                            return "Date cannot be empty";
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      child: TimePickerField(
                        initialValue: time,
                        onSaved: (value) => _time = value,
                        validator: (value) {
                          if (value == null)
                            return "Time cannot be empty";
                          return null;
                        },
                      ),
                    )
                  ],
                ),

                // for duration field
                SizedBox(height: 20,),
                Text("Duration (min)", style: _textFieldTitleTextStyle(),),
                SizedBox(height: 20,),
                  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          if (value != '')
                            _duration = int.parse(value);
                          else
                            _duration = -1;
                        },
                        validator: (value) => _validator(value, "Duration"),
                        initialValue: event?.duration?.toString(),
                      ),
                    ),
                    Expanded(child: SizedBox(),)
                  ],
                ),

                // for venue title
                SizedBox(height: 20,),
                Text("Venue", style: _textFieldTitleTextStyle(),),

                // for venue text field
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        onSaved: (value) => _venue = value,
                        validator: (value) => _validator(value, "Venue"),
                        initialValue: event?.venue,
                      ),
                    ),
                    Expanded(child: SizedBox(),)
                  ],
                ),

                // for description title
                SizedBox(height: 20,),
                Text("Description", style: _textFieldTitleTextStyle()),

                // for description field
                SizedBox(height: 20,),
                TextFormField(
                  maxLines: 5,
                  validator: (value) => _validator(value, "Description"),
                  onSaved: (value) => _description = value,
                  initialValue: event?.description,
                ),
              ],
            ),
          ),
          // for add resources
          SizedBox(height: 20,),
          AddResourcesList(dataStructure: links,),

          SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget _footer() {
    /**
     * Returns widgets at the end of the form. Mostly a delete and done button
     * 
     * Returns:
     *  Widget: The widgets.
     */
    
    List<Widget> children = [];

    children.add(Row(
      children: <Widget>[
        Text("Done", style: _textFieldTitleTextStyle(),),
        SizedBox(width: 10,),
        SizedBox(
          width: 60,
          height: 60,
          child: FlatButton(
            child: Icon(Icons.arrow_forward, size: 30,),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                onSaved(
                  date: _date,
                  time: _time,
                  duration: _duration,
                  title: _title,
                  venue: _venue,
                  by: _by,
                  description: _description,
                  links: _links
                );
              }
            },
            shape: CircleBorder(),
            color: Color(0xffffd500),
          ),
        )
      ],
    ));

    // adding a delete button if the event is not a new event
    if(! isNewEvent && User.getInstance().getClearanceLevel() > 1) {
      children.insert(0, FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.red,
        child: Text("Delete Event", style: _textFieldTitleTextStyle(),),
        onPressed: onDelete
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children
    );
  }

  TextStyle _textFieldTitleTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  String _validator(String value, String field) {
    /**
     * Simple validator for the text form fields.
     * checks if field is empty or not.
     * 
     * Args:
     *  value (String): The value of the field
     *  field (String): The name of the field
     * 
     * Returns:
     *  String: Error message, if value of the field is invalid, null if valid
     */

    if (value.isEmpty) {
      return field + " cannot be empty";
    }
    return null;
  }

}
