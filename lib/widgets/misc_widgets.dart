import 'package:cynergy_app/theme_data.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showStatusDialog({@required BuildContext context, @required String message, @required Function future}) {
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
        title: Text("Status",),
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
                      child: Text("Error has occurred. Try again", style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 10,),
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
                    Text(message, style: TextStyle(fontSize: 18)),
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

void showConfirmDialog({@required BuildContext context, @required String message, @required VoidCallback onConfirm}) {
  /**
   * Shows a yes/no confirmation dialog.
   * 
   * Args:
   *  context (BuildContext): The current [BuildContext]
   *  message (String): The message to be displayed
   *  onConfirm (VoidCallback): The callback to be executed when 'Yes' is pressed.
   * 
   * Returns:
   *  void
   */

  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text("Confirmation"),
        children: <Widget>[
          ListTile(
            title: Text(message,),                  
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Text("Yes",),
                onPressed: onConfirm
              ),
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Text("No",),
                onPressed: () {
                  Navigator.of(context).pop();
                }
              )
            ],
          )
        ], 
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
          Text("Done", style: TextStyle(color: Colors.black)),
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

class SlideFromDownPageRouteBuilder extends PageRouteBuilder {
  SlideFromDownPageRouteBuilder({@required Widget page}) :
    super(
      pageBuilder: (context, anim, secondaryAnim) => page,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            curve: Curves.easeInOutQuint,
            parent: anim
          )),
          child: child,
        );
      }
    );
}
class SlideFromRightPageRouteBuilder extends PageRouteBuilder {
  SlideFromRightPageRouteBuilder({@required Widget page}) :
    super(
      pageBuilder: (context, anim, secondaryAnim) => page,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(
            curve: Curves.easeInOutQuint,
            parent: anim
          )),
          child: child,
        );
      }
    );
}

class BackButtonNoBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.arrow_back_ios, size: 26,),
            SizedBox(width: 20,),
            Text(
              "Back", 
              style: TextStyle(fontWeight: FontWeight.bold)
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}