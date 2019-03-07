import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  final _formkey = GlobalKey<FormState>();
  bool _isFormEnabled = true;

  @override
  Widget build(BuildContext context) {
    final double formChildrenPadding = 20;

    final Form form = Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: "Event Name"
            ),
            enabled: _isFormEnabled,
          ),

          Padding(
            padding: EdgeInsets.all(formChildrenPadding),
          ),

          DateTimePickerFormField(
            format: DateFormat("EE, MMMM d yyyy, 'at' h:mm a"),
            inputType: InputType.both,
            decoration: InputDecoration(
              labelText: 'Date',
            ),
            onChanged: (dt)=>print(dt),
            enabled: _isFormEnabled,
          ),

          Padding(
            padding: EdgeInsets.all(formChildrenPadding),
          ),

          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                labelText: "Event Description"
            ),
            enabled: _isFormEnabled,
          ),

          Padding(
            padding: EdgeInsets.all(formChildrenPadding),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Event type:",
                style: TextStyle(fontSize: 16),
              )
            ]
          )

        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: form,
        )
      ),
    );
  }
}
