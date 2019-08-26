import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class HomePageDots extends StatefulWidget {

  final PageController controller;

  HomePageDots({Key key, @required this.controller}) : super(key: key);

  @override
  _HomePageDotsState createState() => _HomePageDotsState();
}

class _HomePageDotsState extends State<HomePageDots> {

  /// [PageController] this widget should be attached to.
  PageController get _controller => widget.controller;

  /// The current page, used to highlight the dot.
  int _currentPage = 0;

  @override
  void initState() {
    /**
     * Intializes the widget.
     * 
     * Returns:
     *  void
     */
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentPage && this.mounted) {
        setState(() {
          _currentPage = _controller.page.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Builds the dots indicator.
     * 
     * Returns:
     *  Widget: The dots indicator.
     */
    
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