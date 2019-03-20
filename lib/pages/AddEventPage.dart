import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cynergy_app/repository/EventRepository.dart';
import 'package:cynergy_app/services/EventsHandler.dart';
import 'package:cynergy_app/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


enum EventTypes {Workshop, Session, MonthlyContest}

class AddEventPage extends StatefulWidget {

  final EventsHandler handler;

  AddEventPage({@required this.handler}):
      assert(handler != null);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  final _formKey = GlobalKey<FormState>();
  final double _formChildrenPadding = 20;
  bool _isFormEnabled = true;

  String _eventName;
  String _eventTopic;
  DateTime _date;
  int _eventDuration;
  String _description;
  EventTypes _eventType = EventTypes.Workshop;

  EventsHandler get _eventsHandler => widget.handler;


  @override
  Widget build(BuildContext context) {

    final topContent = Container(
      padding: EdgeInsets.only(top: 40, bottom: 60),
      child:Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(
                  child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30
                  ),
                  onTap: ()=>Navigator.pop(context),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text(
              "A New Event!",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            leading: Container(
              padding: EdgeInsets.only(left: 10),
              child:Icon(
                  Icons.event,
                  size: 30,
                  color: Colors.white
              ),
              decoration: BoxDecoration(
                  border: Border(
                      right: new BorderSide(width: 1.0, color: Colors.white)
                  )
              ),
            ),

          ),
        ],
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/events_placeholder.jpg"),
              fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.hardLight)
          )
      ),
    );

    final Widget form = Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: eventNameField()+
            eventTopicField() +
            dateField() +
            durationField() +
            descriptionField() +
            eventTypeField() +
            submitButton()
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topContent,
            form
          ],
        )
      ),
    );
  }

  List<Widget> eventNameField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Name of the event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Event Name",
        ),
        validator: (value){
          if (value == "") return "Event name cannot be empty";
        },
        onSaved: (value)=>_eventName=value,
        enabled: _isFormEnabled,
      ),
      Padding(
        padding: EdgeInsets.all(_formChildrenPadding),
      ),
    ];
  }

  List<Widget> eventTopicField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Topic of the event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Event Topic",
        ),
        validator: (value){
          if (value == "") return "Event topic cannot be empty";
        },
        onSaved: (value)=>_eventTopic=value,
        enabled: _isFormEnabled,
      ),
      Padding(
        padding: EdgeInsets.all(_formChildrenPadding),
      ),
    ];
  }

  List<Widget> dateField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Date and Time of the Event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      DateTimePickerFormField(
        format: DateFormat("EE, MMMM d yyyy, 'at' h:mm a"),
        inputType: InputType.both,
        decoration: InputDecoration(
          labelText: 'Date',
        ),
        validator: (value){
          if(value == null) return "Date cannot be empty";
        },
        onSaved: (value)=>_date = value,
        enabled: _isFormEnabled,
      ),
      Padding(
        padding: EdgeInsets.all(_formChildrenPadding),
      ),
    ];
  }

  List<Widget> durationField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Duration of the event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text("In minutes."),
        ),
      ),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Duration",
        ),
        validator: (value){
          if (value == "") return "Duration cannot be empty";
          if (int.tryParse(value) == null){
            return "Duration must be a number only";
          }
        },
        onSaved: (value)=>_eventDuration=int.parse(value),
        enabled: _isFormEnabled,
      ),
      Padding(
        padding: EdgeInsets.all(_formChildrenPadding),
      ),
    ];
  }

  List<Widget> descriptionField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Description of the Event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text("Give a creative description, but not too long."),
        ),
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
            labelText: "Event Description"
        ),
        validator: (value){
          if(value == "") return "Description cannot be empty";
        },
        onSaved: (value)=>_description = value,
        enabled: _isFormEnabled,
      ),
      Padding(
        padding: EdgeInsets.all(_formChildrenPadding),
      ),
    ];
  }

  List<Widget> eventTypeField(){
    return [
      Flexible(
        fit: FlexFit.loose,
        child: ListTile(
          title: Text("Type of the Event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text("choose one. Don't forget."),
        ),
      ),
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                  title: const Text("Workshop"),
                  value: EventTypes.Workshop,
                  groupValue: _eventType,
                  onChanged: (value){
                    setState(() {
                      _eventType = value;
                    });
                  },
                ),
              ),

              Flexible(
                child: RadioListTile(
                  title: const Text("Session"),
                  value: EventTypes.Session,
                  groupValue: _eventType,
                  onChanged: (value){
                    print("EVENT TYPE: $value");
                    setState(() {
                      _eventType = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                  title: const Text("Monthly Contest"),
                  value: EventTypes.MonthlyContest,
                  groupValue: _eventType,
                  onChanged: (value){
                    setState(() {
                      _eventType = value;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      )
    ];
  }

  List<Widget> submitButton(){
    return [
      IconButton(
        icon: Icon(Icons.cloud_upload),
        iconSize: 30,
        onPressed: ()=>validateAndSubmit(),
      )
    ];
  }

  void validateAndSubmit() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      Map<dynamic, dynamic> details = EventRepository.createDetails(description: _description);
      EventRepository event = EventRepository(
          date: Timestamp.fromDate(_date),
          details: details,
          duration: _eventDuration,
          eventName: _eventName,
          eventTopic: _eventTopic,
          type: enumString(_eventType)
      );

      _showDialog(0);
      bool res = await _eventsHandler.uploadEvent(event: event);
      Navigator.pop(context);
      if(res) {
        _showDialog(1);
        _formKey.currentState?.reset();
      }
      else
        _showDialog(2);
    }
  }

  String enumString(EventTypes type){
    switch(type){
      case EventTypes.Workshop:
        return "Workshop";

      case EventTypes.MonthlyContest:
        return "Monthly Contest";

      case EventTypes.Session:
        return "Session";
    }

    return null;
  }

  void _showDialog(int type){
    // loading screen
    bool _willPop = true;
    Widget _content;

    if (type == 0) {
      // uploading event loading
      _willPop = false;
      _content = Container(
          width: 80,
          height: 200,
          child: LoadingIndicator(),
      );

    }else if (type == 1){
      // uploading event successful
      _willPop = true;
      _content = Text("Event uploaded!");
    }else{
      // error uploading event
      _willPop = true;
      _content = Text("Error uploading!");
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => _willPop,
          child: AlertDialog(
              title: Text("Uploading Event"),
              content: _content
          ),
        );
      }
    );
  }
}
