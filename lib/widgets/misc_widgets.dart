import 'package:cynergy_app/theme_data.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showStatusDialog(BuildContext context, String message, Function future) {
/**
   * Shows the dialog and executes the given future. The dialog shows a [CircularProgressIndicator]
   * When the future is not finished executing, and shows a message for sometime once the future
   * finishes executing. After the time has passed, [Route]s until the first [Route] are popped
   * from the current context.
   * 
   * Args:
   *  context (BuildContext): The current [BuildContext]
   *  message (String): The message to be displayed once the future executes
   *  future (Function): The [Future] to be executed.
   * 
   * Returns:
   *  void
   */

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        title: Text("Status", style: TextStyle(fontFamily: "Poppins"),),
        children: <Widget> [
          FutureBuilder(
            future: future(),
            builder: (context, snapshot) {
              Widget body;
              if (snapshot.hasError) {
                body = Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text("Error has occurred. Try again", style: TextStyle(fontFamily: "Poppins", fontSize: 18)),
                    ),
                    SizedBox(height: 20,),
                    _doneButton(() {
                        Navigator.of(context).popUntil((route) {
                        return route.isFirst;
                      });
                    })
                  ],
                );
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                body = Column(
                  children: <Widget>[
                    Text(message, style: TextStyle(fontFamily: "Poppins", fontSize: 18)),
                    SizedBox(height: 40,),
                    _doneButton(() {
                        Navigator.of(context).popUntil((route) {
                        return route.isFirst;
                      });
                    })
                  ],
                );
              } 
              else {
                body = Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(
                height: 150,
                width: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 150),
                      child: body,
                    )
                  ],
                ),
              );
            },
          ),
        ]
      );
    }
  );
}

Widget _doneButton(Function() onPressed) {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20) 
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Done", style: TextStyle(fontFamily: "Poppins", color: Colors.black)),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffffd500)
            ),
            child: Icon(Icons.arrow_forward, color: Colors.white,)
          )
        ],
      ),
    ),
    onTap: onPressed
  );
  }

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

