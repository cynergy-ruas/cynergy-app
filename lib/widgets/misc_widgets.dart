import 'package:flutter/material.dart';

class AntiClockwiseDiagonalClipper extends CustomClipper<Path> {
  /// A clipper that runs from the bottom left to top right.
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 60.0);
    path.lineTo(size.width, 0.0);
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