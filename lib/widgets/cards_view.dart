import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/event_card.dart';
import 'package:flutter/material.dart';

typedef void CardTapCallback (dynamic);

class CardView extends StatefulWidget {

  final List<Event> events;
  final int itemCount;
  final bool buildSkeleton;
  final CardTapCallback onCardTap;

  CardView({Key key, @required this.events, @required this.itemCount, @required this.onCardTap, this.buildSkeleton = false}):
    super(key: key);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  List<Event> get events => widget.events;
  int get itemCount => widget.itemCount;
  bool get buildSkeleton => widget.buildSkeleton;
  CardTapCallback get onCardTap => widget.onCardTap;

  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.48,
      child: PageView.builder(
        controller: pageController,
        itemCount: itemCount,
        itemBuilder: (context, position) {
          return EventCard(
            event: events?.elementAt(position),
            offset: pageOffset - position,
            buildSkeleton: buildSkeleton,
            onTap: onCardTap,
          );
        },
      )
    );
  }
}