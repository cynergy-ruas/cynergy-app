import 'package:flutter/material.dart';
import 'package:cynergy_app/theme_data.dart';

List<Widget> loadingModalBarrier() {
  /*
  Returns a list containing a modal barrier and circularprogressindicator.

  Returns:
    List<Widget>: List of the mentioned widgets.
  */
  
  return [
    Opacity(
      opacity: 0.3,
      child: ModalBarrier(dismissible: false, color: gradientDarkGrey)
    ),
    Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: new CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorLightOrange),
        ),
      )
    )
  ];
}