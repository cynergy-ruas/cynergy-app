import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/event_card.dart';
import 'package:flutter/material.dart';

typedef void CardTapCallback (dynamic);

class CardView extends StatefulWidget {

  /// the list of events
  final List<Event> events;

  /// The number of events
  final int itemCount;

  /// boolean that says whether to build a skeleton or render the
  /// event details.
  final bool buildSkeleton;

  /// Callback that runs when card is tapped
  final CardTapCallback onCardTap;

  CardView({Key key, @required this.events, @required this.itemCount, @required this.onCardTap, this.buildSkeleton = false}):
    super(key: key);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  /// Getting the variables from the [CardView] class.
  List<Event> get events => widget.events;
  int get itemCount => widget.itemCount;
  bool get buildSkeleton => widget.buildSkeleton;
  CardTapCallback get onCardTap => widget.onCardTap;

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
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: pageController,
        itemCount: itemCount,
        itemBuilder: (context, position) {
          return EventCard(
            event: events?.elementAt(position),
            offset: pageOffset - position,
            buildSkeleton: buildSkeleton,
            onTap: onCardTap,
            height: height,
          );
        },
      )
    );
  }
}