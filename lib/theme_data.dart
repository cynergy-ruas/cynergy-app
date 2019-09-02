// All stuff related to themeing and other misc stuff related to ui goes here.

import 'package:flutter/material.dart';

final gradientPurple = Color(0xffa556c3);
final purple = Color(0xff6200ee);
final grey = Color(0xff707070);
final gradientLightYellow = Color(0xffec9d7d);
final gradientLightGrey = Color(0xff232633);
final gradientDarkGrey = Color(0xff171821);
final colorLightOrange = Color(0xffea7e73);

final darkBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [gradientLightGrey, gradientDarkGrey],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  )
);

InputDecoration textFieldInputDecoration ({@required double textFieldRadius, @required Icon icon, String hintText = ""}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(textFieldRadius))
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(textFieldRadius)),
      borderSide: BorderSide(color: Color(0x00000000))
    ),
    fillColor: Color(0xff323444),
    filled: true,
    icon: icon,
    hintText: hintText,
    hintStyle: TextStyle(color: Color(0x20ffffff))
  );
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xff121212),
  dialogBackgroundColor: Color(0xff373737),
  dividerColor: Colors.white,
  accentColor: Color(0xff6200ee),
  disabledColor: Color(0xff707070),
  cursorColor: Colors.white,
  textSelectionHandleColor: Color(0xff6200ee),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color(0xff4c4c4c),
    filled: true,
    contentPadding: EdgeInsets.all(12),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.transparent, width: 1.0)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.transparent, width: 1.0)
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.transparent, width: 1.0)
    ),
  )
);