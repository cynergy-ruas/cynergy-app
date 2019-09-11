import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/models/user_model.dart';
import 'package:cynergy_app/pages/edit_event_page.dart';
import 'package:cynergy_app/pages/events_info_page.dart';
import 'package:cynergy_app/pages/events_page.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class EventCard extends StatelessWidget {

  /// The event whose details are to be rendered.
  final Event event;

  /// The offset of the card. Used for the animation.
  final double offset;

  /// Height of the card.
  final double height;

  /// determines whether the animations should be applied or not.
  final bool shouldAnimate;

  EventCard({Key key, @required this.event, @required this.offset, @required this.height, this.shouldAnimate = false});

  @override
  Widget build(BuildContext context) {
    double gauss;

    if (shouldAnimate)
      /// converting offset to a gaussian distribution. Cooler animation.
      gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    Widget card = GestureDetector(
      child: Card(
        color: Theme.of(context).accentColor,
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _backgroundImage(),
                _CardHeader(event: event, offset: gauss, shouldAnimate: shouldAnimate,),
                Positioned(
                  top: this.height * 0.53,
                  right: 10,
                  child: _button(context)
                )
              ],
            ),
            _CardFooter(event: event, offset: gauss, shouldAnimate: shouldAnimate,)
          ],
        )
      ),
      onTap: () {
        Widget page = EventsInfoPage(event: event,);
        Navigator.of(context).push(SlideFromDownPageRouteBuilder(page: page));
      },
    );

    if (shouldAnimate)
      return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: card
      );
    return card;
  }

  Widget _button(BuildContext context) {
    /**
     * Build the info button (for normal members) or the edit
     * button (for coordinators)
     * 
     * Args:
     *  context (BuildContext): The build context.
     * 
     * Returns
     *  Widget: The button
     */

    return RawMaterialButton(
      onPressed: () {
        Widget page = (User.getInstance().isCoordinator())
          ? EventsEditPage(event: event, handler: InheritedEventHandler.of(context).handler)
          : EventsInfoPage(event: event,);

        Navigator.of(context).push(SlideFromDownPageRouteBuilder(page: page));
      },
      child: (User.getInstance().isCoordinator())
        ? Icon(Icons.edit, color: Colors.black)
        : _dots(),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(10.0),
    );
  }

  Widget _dots() {
    /**
     * Build a widget that functions as an Icon of sorts.
     * The three vertical dots.
     * 
     * Returns:
     *  Widget: The widget.
     */

    Container _circleContainer = Container(
      height: 6,
      width: 6,
      decoration: new BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );

    return Column(
      children: <Widget>[
        _circleContainer,
        SizedBox(height: 5,),
        _circleContainer,
        SizedBox(height: 5,),
        _circleContainer
      ],
    );
  }

  Widget _backgroundImage() {
    /**
     * Builds the clipped background image.
     * 
     * Returns:
     *  Widget: The background image
     */

    return Container(
      height: this.height * 0.7,
      child: ClipPath(
        clipper: AntiClockwiseDiagonalClipper(),
        child: Image.asset(
          'assets/images/events_placeholder.jpg',
          fit: BoxFit.none,
          alignment: (shouldAnimate) ? Alignment(-offset.abs(), 0): Alignment(0, 0),
          color: Colors.grey.withOpacity(0.5),
          colorBlendMode: BlendMode.srcOver,
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {

  final Event event;
  final double offset;
  final bool shouldAnimate;

  _CardHeader({@required this.event, @required this.offset, @required this.shouldAnimate});

  @override
  Widget build(BuildContext context) {
    /**
     * Builds the contents on the top part of the card.
     * Contains the title and the description.
     * 
     * Returns:
     *  Widget: The contents.
     */

    Widget content = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Center(
            child: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Center(
            child: Text(
              (event.description.length > 75)
              ? removeTrailingCharacters(event.description.substring(0, 74)) + " . . ."
              : event.description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
            ),
          )
        )
      ],
    );

    return Padding(
      padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (shouldAnimate) 
          ? Transform.translate(
              offset: Offset(32 * offset, 0),
              child: content
            )
          : content
        ],
      )
    );
  }

  String removeTrailingCharacters(String str) {
    /**
     * Removes trailing characters from a word. Stops when space is encountered.
     * 
     * Args:
     *  str (String): The input string
     * 
     * Returns:
     *  str(String): The result
     */

    int index = str.lastIndexOf(" ");
    return str.substring(0, index);
    
  }

}

class _CardFooter extends StatelessWidget {

  final Event event;
  final double offset;
  final bool shouldAnimate;

  _CardFooter({@required this.event, @required this.offset, @required this.shouldAnimate});

  @override
  Widget build(BuildContext context) {
    /**
     * Build the bottom part of the card. Contains the text for
     * Date, Time and Venue
     * 
     * Returns:
     *  Widget: The contents.
     */

    TextStyle style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16
    );

    Widget content = Column(
      children: <Widget>[
        Text(
          "Date: " + event.getShortDate(),
          style: style
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Time: " + event.getTime(),
            style: style,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Venue: " + event.venue,
            style: style,
          ),
        ),
      ],
    );

    if (shouldAnimate) 
      return Transform.translate(
        offset: Offset(offset * 32, 0),
        child: content
      );
    return content;
  }
}
