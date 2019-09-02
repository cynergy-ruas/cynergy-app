import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/add_resources_list.dart';
import 'package:flutter/material.dart';

import 'misc_widgets.dart';

class EventForm extends StatefulWidget {
  /// Widget that represents an [Event] as an interactable interface.
  
  /// the event
  final Event event;
  
  /// controller to access the title field
  final TextEditingController titleController;

  /// controller to access the by field
  final TextEditingController byController;

  /// controller to access the date field
  final TextEditingController dateController;
  
  /// controller to access the time field
  final TextEditingController timeController;
  
  /// controller to access the venue field
  final TextEditingController venueContoller;
  
  /// controller to access the description field
  final TextEditingController descriptionController;

  /// specifies whether the event being represented is a 
  /// new event or not. This is needed for the "Delete Event"
  /// button.
  final bool isNewEvent;

  /// called when done button is clicked.
  final VoidCallback onDone;

  /// called when delete event button is clicked
  final VoidCallback onDelete;

  EventForm({this.event, @required this.titleController, @required this.byController, @required this.dateController, @required this.timeController, 
             @required this.venueContoller, @required this.descriptionController, @required this.isNewEvent, @required this.onDone, 
             this.onDelete}) :
    assert((isNewEvent && onDelete == null) || (! isNewEvent && onDelete != null));

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  Event get event => widget.event;

  bool get isNewEvent => widget.isNewEvent;

  VoidCallback get onDone => widget.onDone;
  VoidCallback get onDelete => widget.onDelete;

  TextEditingController get titleController => widget.titleController;
  TextEditingController get byController => widget.byController;
  TextEditingController get dateController => widget.dateController;
  TextEditingController get timeController => widget.timeController;
  TextEditingController get venueController => widget.venueContoller;
  TextEditingController get descriptionController => widget.descriptionController;

  List links;

  @override
  void initState() {
    super.initState();

    links = List();
    if (event != null)
      links.addAll(event.getLinks());
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
            _backButton(context),

            // The fields
            SizedBox(height: 20,),
            Expanded(
              child: _form(context, links),
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

    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ScrollConfiguration(
        behavior: NoGlowingOverscrollBehaviour(),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // for title
            Text("Title", style: _textFieldTitleTextStyle(),),
            SizedBox(height: 20,),
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              maxLines: 1,
            ),
            SizedBox(height: 20,),

            // for by field
            Text("By", style: _textFieldTitleTextStyle(),),
            SizedBox(height: 20,),
            TextFormField(
              controller: byController,
              textCapitalization: TextCapitalization.words,
              maxLines: 1,
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
                    controller: dateController,
                  ),
                ),
                SizedBox(width: 30,),
                Expanded(
                  child: TimePickerField(
                    controller: timeController,
                  ),
                )
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
                    controller: venueController,
                    textCapitalization: TextCapitalization.characters,
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
              controller: descriptionController,
              maxLines: 5,
            ),

            // for add resources
            SizedBox(height: 20,),
            AddResourcesList(dataStructure: links,),

            SizedBox(height: 30,)
          ],
        ),
      )
    );
  }

  Widget _backButton(BuildContext context) {
    /**
     * Build the back button.
     * 
     * Args:
     *  context (BuildContext): The current [BuildContext]
     * 
     * Returns:
     *  Widget: The back button
     */

    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.arrow_back_ios, size: 26,),
          SizedBox(width: 20,),
          Text(
            "Back", 
            style: _textFieldTitleTextStyle()
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
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
            onPressed: onDone,
            shape: CircleBorder(),
            color: Color(0xffffd500),
          ),
        )
      ],
    ));

    // adding a delete button if the event is not a new event
    if(! isNewEvent) {
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
      fontFamily: "Poppins"
    );
  }

}
