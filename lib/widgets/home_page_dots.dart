import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class HomePageDots extends StatefulWidget {

  final PageController controller;

  HomePageDots({Key key, @required this.controller}) : super(key: key);

  @override
  _HomePageDotsState createState() => _HomePageDotsState();
}

class _HomePageDotsState extends State<HomePageDots> {

  PageController get _controller => widget.controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentPage) {
        setState(() {
          _currentPage = _controller.page.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: 2,
      position: _currentPage,
      axis: Axis.vertical,
      decorator: DotsDecorator(
        activeColor: Colors.black,
        color: Theme.of(context).disabledColor
      ),
    );
  }
}