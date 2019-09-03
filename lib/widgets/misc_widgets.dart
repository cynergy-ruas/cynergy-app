import 'package:cynergy_app/theme_data.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AntiClockwiseDiagonalClipper extends CustomClipper<Path> {
  /// A clipper that runs from the bottom left to top right.
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, (size.height * 0.81));
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class EventsTabClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - (size.height * 0.4), 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
  
}

class NoGlowingOverscrollBehaviour extends ScrollBehavior {
  /// class that is used to remove the glowing overscroll effect
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class DatePickerField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  final void Function(DateTime) onSaved;
  final String Function(DateTime) validator;
  final DateTime initialValue;

  DatePickerField({this.onSaved, this.validator, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      onSaved: (value) => onSaved(value),
      validator: (value) => validator(value),
      initialValue: initialValue,
      format: format,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              child: child,
              data: darkTheme,
            );
          }
        );
      },
    );
  }
}

class TimePickerField extends StatelessWidget {
  final format = DateFormat("hh:mm a");
  final void Function(DateTime) onSaved;
  final String Function(DateTime) validator;
  final DateTime initialValue;

  TimePickerField({this.onSaved, this.validator, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      onSaved: (value) => onSaved(value),
      validator: (value) => validator(value),
      initialValue: initialValue,
      format: format,
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
    );
  }
}

