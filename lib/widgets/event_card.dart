import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';

import 'package:cynergy_app/theme_data.dart' as theme_data;

import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

typedef CardTapCallback (dynamic);


class EventCard extends StatelessWidget {

  /// The event whose details are to be rendered.
  final Event event;

  /// The offset of the card. Used for the animation.
  final double offset;

  /// boolean that defines whether the skeleton should be built
  /// or not.
  final bool buildSkeleton;

  /// Callback that is called when the card is tapped.
  final CardTapCallback onTap;

  /// Height of the card.
  final double height;

  EventCard({Key key, @required this.event, @required this.offset, @required this.onTap, this.buildSkeleton = false, @required this.height});

  @override
  Widget build(BuildContext context) {
    /// converting offset to a gaussian distribution. Cooler animation.
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    Widget card = GestureDetector(
      child: Card(
        color: theme_data.purple,
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _backgroundImage(),
                _CardHeader(event: event, offset: gauss, buildSkeleton: buildSkeleton,),
                Positioned(
                  top: this.height * 0.54,
                  right: 10,
                  child: _button()
                )
              ],
            ),
            _CardFooter(event: event, offset: gauss, buildSkeleton: buildSkeleton,)
          ],
        )
      ),
      onTap: () {
        onTap(event);
      },
    );

    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: (buildSkeleton)
      ? card
      : Hero(
          tag: event.name,
          child: card,
      )
    );
  }

  Widget _button() {
    /**
     * Build the info button (for normal members) or the edit
     * button (for coordinators)
     * 
     * Returns
     *  Widget: The button
     */

    return RawMaterialButton(
      onPressed: () {},
      child: _dots(),
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

    if (! buildSkeleton)
      return Container(
        height: this.height * 0.7,
        child: ClipPath(
          clipper: AntiClockwiseDiagonalClipper(),
          child: Image.asset(
            'assets/images/events_placeholder.jpg',
            fit: BoxFit.none,
            alignment: Alignment(-offset.abs(), 0),
            color: Colors.grey.withOpacity(0.5),
            colorBlendMode: BlendMode.srcOver,
          ),
        ),
      );
    
    return shimmerBox(height: this.height * 0.7);
  }
}

class _CardHeader extends StatelessWidget {

  final Event event;
  final double offset;
  final bool buildSkeleton;

  _CardHeader({this.event, this.offset, this.buildSkeleton = false});

  @override
  Widget build(BuildContext context) {
    /**
     * Builds the contents on the top part of the card.
     * Contains the title and the description.
     * 
     * Returns:
     *  Widget: The contents.
     */

    return Padding(
      padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: (buildSkeleton)
              ? shimmerBox()
              : Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Center(
                      child: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: Center(
                      child: Text(
                        event.getDescription(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    )
                  )
                ],
              )
          )
        ],
      )
    );
  }
}

class _CardFooter extends StatelessWidget {

  final Event event;
  final double offset;
  final bool buildSkeleton;

  _CardFooter({this.event, this.offset, this.buildSkeleton = false});

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

    return Transform.translate(
      offset: Offset(offset * 32, 0),
      child: Column(
        children: <Widget>[
          Text(
            "Date: " + event.getShortDate(),
            style: style
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Time: ",
              style: style,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Venue: ",
              style: style,
            ),
          ),
        ],
      )
    );
  }
}

Widget shimmerBox({double  height}) {
  /**
   * Build the skeleton.
   * 
   * Returns:
   *  Widget: The skeleton.
   */

  if (height != null) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
      child: Container(
        height: height,
        color: Colors.white,
      )
    );
  }

  Widget shimmer = Shimmer.fromColors(
    baseColor: Colors.grey[200],
    highlightColor: Colors.white,
    child: Container(
      height: 25,
      color: Colors.white,
    )
  );

  return ListTile(
    title: shimmer,
    subtitle: Padding(
      padding: EdgeInsets.only(top: 15),
      child: shimmer
    )
  );
}