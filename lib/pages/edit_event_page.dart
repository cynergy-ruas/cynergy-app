import 'package:Cynergy/models/events_model.dart';
import 'package:Cynergy/widgets/event_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsEditPage extends StatelessWidget {
  
  final Event event;

  /// controller to access the title field
  final TextEditingController _titleController = TextEditingController();

  /// controller to access the by field
  final TextEditingController _byController = TextEditingController();

  /// controller to access the date field
  final TextEditingController _dateController = TextEditingController();

  /// controller to access the time field
  final TextEditingController _timeController = TextEditingController();

  /// controller to access the venue field
  final TextEditingController _venueContoller = TextEditingController();

  /// controller to access the description field
  final TextEditingController _descriptionController = TextEditingController();

  EventsEditPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    _titleController.text = event.name;
    _byController.text = event.by;
    _dateController.text = DateFormat("dd-MM-yy").format(event.date.toDate());
    _timeController.text = DateFormat("hh:mm a").format(event.date.toDate());
    _venueContoller.text = event.venue;
    _descriptionController.text = event.getDescription();

    return EventForm(
      event: event,
      titleController: _titleController,
      byController: _byController,
      dateController: _dateController,
      timeController: _timeController,
      venueContoller: _venueContoller,
      descriptionController: _descriptionController,
      isNewEvent: false,
      onDone: () {},
      onDelete: () {},
    );

  }
}