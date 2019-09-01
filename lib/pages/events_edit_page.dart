import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';

class EventsEditPage extends StatelessWidget {
  
  final Event event;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueContoller = TextEditingController();
  final TextEditingController _decriptionController = TextEditingController();

  EventsEditPage({@required this.event});

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
              child: _form(context),
            ),
            // The footer buttons
            SizedBox(height: 20,),
            _footer(),
          ],
        ),
      )
    );
  }

  Widget _form(BuildContext context) {
    /**
     * Build the form.
     * 
     * Args:
     *  context (BuildContext): The current [BuildContext]
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
          children: <Widget>[
            // for title
            Text("Title", style: _textFieldTitleTextStyle(),),
            SizedBox(height: 20,),
            TextFormField(
              controller: _titleController,
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
                    controller: _dateController,
                  ),
                ),
                SizedBox(width: 30,),
                Expanded(
                  child: TimePickerField(
                    controller: _timeController,
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
                    controller: _venueContoller,
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
              controller: _decriptionController,
              maxLines: 5,
            )
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.red,
          child: Text("Delete Event", style: _textFieldTitleTextStyle(),),
          onPressed: () {},
        ),

        Row(
          children: <Widget>[
            Text("Done", style: _textFieldTitleTextStyle(),),
            SizedBox(width: 10,),
            SizedBox(
              width: 60,
              height: 60,
              child: FlatButton(
                child: Icon(Icons.arrow_forward, size: 30,),
                onPressed: () {},
                shape: CircleBorder(),
                color: Color(0xffffd500),
              ),
            )
          ],
        )
      ],
    );
  }

  TextStyle _textFieldTitleTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins"
    );
  }
}