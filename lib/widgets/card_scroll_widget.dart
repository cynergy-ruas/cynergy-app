import 'dart:math';
import 'package:cynergy_app/theme_data.dart';
import 'package:flutter/material.dart';

typedef Widget CardBuilderCallback(dynamic item);
typedef void CardTapCallback(dynamic item);

class CardScrollWidget extends StatelessWidget {
  final double currentPage;
  final List items;        // The items that the widget will display as cards
  final int itemCount;
  final CardBuilderCallback cardBuilder;  // callback that will be called when building the cards
  final CardTapCallback onCardTap;    // callback that will be called when a card is tapped
  final PageController controller;   // the [PageController] that controls the [PageView]
  final double padding;
  final double verticalInset;  // controls the height of the 'cards' underneath the top 'card'
  final double cardAspectRatio;

  CardScrollWidget({key, @required this.controller, @required this.currentPage, @required this.items, @required this.cardBuilder,
    @required this.itemCount, this.onCardTap, this.padding = 20.0, this.verticalInset = 20.0, this.cardAspectRatio = 12.0 / 16.0}) : 
    super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * Creates the card scroll view.
     * 
     * Args:
     *  context (BuildContext): The build context
     * 
     * Returns:
     *  Stack: The view.
     */

    final widgetAspectRatio = cardAspectRatio * 1.2;

    AspectRatio aspectRatio = AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          List<Widget> cardList = new List();

          for (var i = 0; i < itemCount; i++) {
            // the [currentPage] value (which is a double) changes with the page controller.
            // The page controller only provides a way to change the [currentPage] upon touch.
            // The animation is performed by the [start] and the [Positioned.directional]'s
            // [top] and [bottom] parameters (in [cardItem] function). [start] controls the 
            // horizontal position of the 'card', whereas, [top] and [bottom] in 
            // [Positioned.directional] controls the height of the 'card'. These values are
            // changed due to the fact that [setState] is called whenever the [PageView] is
            // touched.
            var delta = i - currentPage;
            bool isOnRight = delta > 0;

            var start = padding +
                max(
                  primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0
                );
            cardList.add(cardItem(items?.elementAt(i), start, delta));
          }
          return Stack(children: cardList,);
        },
      ),
    );

    return Stack(
      children: <Widget>[
        aspectRatio,
        ScrollConfiguration(
          behavior: NoGlowingOverscrollBehaviour(),
          child: Positioned.fill(
            child: PageView.builder(
              itemCount: itemCount,
              controller: controller,
              reverse: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(),
                  onTap: () {
                    if (onCardTap != null)
                      onCardTap(items[index]);
                  },
                  behavior: HitTestBehavior.translucent,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget cardItem(item, double start, double delta) {
    /** 
     * Creates card items.
     * 
     * Args:
     *  item: The item for which the card has to be made.
     *  start (double): The start position of the card.
     *  delta (double): The difference between the current item position in the list and current card
     *  being shown.
     * 
     * Returns:
     *  Positioned.directional: The card.
    */

    return Positioned.directional(
      top: padding + verticalInset * max(-delta, 0.0),
      bottom: padding + verticalInset * max(-delta, 0.0),
      start: start,
      textDirection: TextDirection.rtl,
      child: AspectRatio(
        aspectRatio: cardAspectRatio,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: cardBuilder(item),
        ),
      )
    );
  }
}