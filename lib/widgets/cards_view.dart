import 'package:Cynergy/models/events_model.dart';
import 'package:Cynergy/widgets/event_card.dart';
import 'package:Cynergy/widgets/events_tab.dart';
import 'package:flutter/material.dart';

class CardView extends StatefulWidget {

  /// the list of events
  final List<Event> events;

  /// The number of events
  final int itemCount;

  /// determines whether the animation should be applied or not
  final bool shouldAnimate;

  CardView({Key key, @required this.events, @required this.itemCount, @required this.shouldAnimate}):
    super(key: key);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  /// Getting the variables from the [CardView] class.
  List<Event> get events => widget.events;
  int get itemCount => widget.itemCount;
  bool get shouldAnimate => widget.shouldAnimate;

  PageController pageController;

  /// offset of each card. used for the animation.
  double pageOffset = 0;

  @override
  void initState() {
    /**
     * Initializing.
     */

    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    if (shouldAnimate)
      pageController.addListener(() {
        setState(() => pageOffset = pageController.page);
      });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Building the widget.
     * 
     * Returns:
     *  Widget: The Card View.
     */
    
    double height = MediaQuery.of(context).size.height * 0.60;
    double width = MediaQuery.of(context).size.width * 0.8;

    Widget body = SizedBox(
      height: height,
      child: PageView.builder(
        controller: pageController,
        itemCount: itemCount,
        itemBuilder: (context, position) {
          return EventCard(
            event: events?.elementAt(position),
            offset: pageOffset - position,
            height: height,
            shouldAnimate: shouldAnimate,
          );
        },
      )
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        EventsTabBar(
          width: width,
          height: 50,
          tabWidth: width * 0.4,
          parent: pageController,
          onUpcomingTap: () async {
            if (EventPool.getIndexOfFirstPastEvent() != 0) 
              await pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOutQuad
              );
          },
          onPastTap: () async{
            await pageController.animateToPage(
              EventPool.getIndexOfFirstPastEvent(),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutQuad
            );
          },
        ),
        SizedBox(height: 50,),
        body
      ],
    );
  }
}