import 'package:cynergy_app/widgets/event_form.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    return EventForm(
      titleController: _titleController,
      byController: _byController,
      dateController: _dateController,
      timeController: _timeController,
      venueContoller: _venueContoller,
      descriptionController: _descriptionController,
      isNewEvent: true,
      onDone: () {},
    );

  }
}