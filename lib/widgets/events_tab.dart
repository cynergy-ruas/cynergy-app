import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cynergy_app/theme_data.dart' as theme_data;

typedef OnTapCallback ();

class EventsTab extends StatefulWidget {

  final double width;
  final double height;
  final double tabWidth;
  final OnTapCallback onUpcomingTap;
  final OnTapCallback onPastTap;
  final PageController parent;

  EventsTab({@required this.width, @required this.tabWidth, @required this.onUpcomingTap, @required this.onPastTap, 
  @required this.parent, this.height});

  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> with TickerProviderStateMixin {

  AnimationController _animationController;
  Animation _slidingAnimation;
  Animation _colorFadeAnimation;
  Animation _colorDarkenAnimation;
  Animation _fontSizeReduceAnimation;
  Animation _fontSizeIncreaseAnimation;
  Animation _fontColorFadeAnimation;
  Animation _fontColorDarkenAnimation;

  double get totalWidth => widget.width;
  double get totalHeight => widget.height;
  double get tabWidth => widget.tabWidth;
  PageController get parent => widget.parent;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _slidingAnimation = Tween(
        begin: ((totalWidth - tabWidth) / tabWidth) + 0.25,
        end: 1.0
      ).animate(CurvedAnimation(
        curve: Curves.easeInOutQuint,
        parent: _animationController
      )
    );
    _colorFadeAnimation = ColorTween(
        begin: theme_data.purple,
        end: Colors.white
    ).animate(_animationController);

    _colorDarkenAnimation = ColorTween(
      begin: Colors.white,
      end: theme_data.purple,
    ).animate(_animationController);

    _fontSizeReduceAnimation = Tween(
      begin: 20.0,
      end: 16.0
    ).animate(CurvedAnimation(
      curve: Curves.easeInOutQuint,
      parent: _animationController
    ));

    _fontSizeIncreaseAnimation = Tween(
      begin: 16.0,
      end: 20.0
    ).animate(CurvedAnimation(
      curve: Curves.easeInOutQuint,
      parent: _animationController
    ));

    _fontColorFadeAnimation = ColorTween(
      begin: theme_data.grey,
      end: Colors.white
    ).animate(_animationController);

    _fontColorDarkenAnimation = ColorTween(
      begin: Colors.white,
      end: theme_data.grey
    ).animate(_animationController);

    parent.addListener(() {
      if (parent.page < EventPool.getIndexOfFirstPastEvent() - 0.5 && ! _animationController.isAnimating) {
        _animationController.reverse();
      }
      
      else if (parent.page >= EventPool.getIndexOfFirstPastEvent() - 0.5 && ! _animationController.isAnimating) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (EventPool.getIndexOfFirstPastEvent() == 0) {
      _animationController.forward();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: totalHeight,
        width: totalWidth,
        child: _tabs()
      ),
    );
  }

  Widget _tabs() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: <Widget>[
            /// The background
            Container(
              width: totalWidth,
              height: totalHeight - 0.5,
              color: _colorDarkenAnimation.value,
            ),
            
            /// The tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: EventsTabClipperLeft(),
                  child: GestureDetector(
                    child: Container(
                      width: tabWidth * _slidingAnimation.value,
                      color: _colorFadeAnimation.value,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                            color: _fontColorDarkenAnimation.value,
                            fontWeight: FontWeight.bold,
                            fontSize: _fontSizeReduceAnimation.value
                          ),
                        ),
                      )
                    ),
                    onTap: () {
                      widget.onUpcomingTap();
                    },
                  )
                ),
                GestureDetector(
                  child: Container(
                    width: totalWidth - (tabWidth * _slidingAnimation.value),
                    color: _colorDarkenAnimation.value,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Past",
                        style: TextStyle(
                          color: _fontColorFadeAnimation.value,
                          fontWeight: FontWeight.bold,
                          fontSize: _fontSizeIncreaseAnimation.value
                        ),
                      ),
                    )
                  ),
                  onTap: () {
                    widget.onPastTap();
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}