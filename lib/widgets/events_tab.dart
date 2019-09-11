import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cynergy_app/theme_data.dart' as theme_data;

typedef OnTapCallback ();

class EventsTabBar extends StatefulWidget {

  /// width of the tab bar
  final double width;

  /// height of the tab bar
  final double height;

  /// width of a tab
  final double tabWidth;

  /// Callback that is executed when the "Upcoming" tab is clicked
  final OnTapCallback onUpcomingTap;

  /// Callback that is executed when the "Past" tab is clicked
  final OnTapCallback onPastTap;

  /// The Page Controller of the parent widget (The [CardsView] widget)
  final PageController parent;

  EventsTabBar({@required this.width, @required this.tabWidth, @required this.onUpcomingTap, @required this.onPastTap, 
  @required this.parent, this.height});

  @override
  _EventsTabBarState createState() => _EventsTabBarState();
}

class _EventsTabBarState extends State<EventsTabBar> with TickerProviderStateMixin {


  /// The animation controller
  AnimationController _animationController;

  /// The animation for sliding the [EventsTabClipperLeft]
  Animation _slidingAnimation;

  /// The animation to fade the tab color to white
  Animation _colorFadeAnimation;

  /// The animation to darken the tab color from white
  Animation _colorDarkenAnimation;

  /// The animation to reduce the font size
  Animation _fontSizeReduceAnimation;

  /// The animation to increase the font size
  Animation _fontSizeIncreaseAnimation;

  /// The animation to fade the font color to white
  Animation _fontColorFadeAnimation;

  /// The animation to darken the font color from white
  Animation _fontColorDarkenAnimation;

  /// Getting vars from [EventsTabBar]
  double get totalWidth => widget.width;
  double get totalHeight => widget.height;
  double get tabWidth => widget.tabWidth;
  PageController get parent => widget.parent;
  
  @override
  void initState() {
    /**
     * Initializes the widget. The animations and tweens are intialized here.
     * 
     * Returns:
     *  null
     */

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

    // adding a listener to the [PageController] so that the currently selected tab switches when
    // the correct page is reached.
    parent.addListener(() {

      // If the current page is an event which is upcoming, make currently selected tab "Upcoming"
      if (parent.page < EventPool.getIndexOfFirstPastEvent() - 0.5 && ! _animationController.isAnimating) {
        _animationController.reverse();
      }
      
      // if the current page is a past event, make currently selected tab "Past"
      else if (parent.page >= EventPool.getIndexOfFirstPastEvent() - 0.5 && ! _animationController.isAnimating) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    /**
     * Builds the Widget
     * 
     * Returns:
     *  Widget: The tab bar.
     */

    // If there are no upcoming events, make currently selected tab "Past"
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
            // The background
            Container(
              width: totalWidth,
              height: totalHeight - 0.5,
              color: _colorDarkenAnimation.value,
            ),
            
            // The tabs
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