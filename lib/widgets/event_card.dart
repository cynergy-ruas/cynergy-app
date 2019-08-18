import 'package:cynergy_app/models/events_model.dart';
import 'package:cynergy_app/widgets/card_scroll_widget.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

class EventCard extends StatelessWidget {

  final Event event;
  final double offset;
  final bool buildSkeleton;
  final CardTapCallback onTap;

  EventCard({Key key, @required this.event, @required this.offset, @required this.onTap, this.buildSkeleton = false});

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    double height = MediaQuery.of(context).size.height * 0.3;

    Widget card = GestureDetector(
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: buildSkeleton
              ? shimmerBox(height: height)
              : Image.asset(
                  'assets/images/events_placeholder.jpg',
                  height: height,
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
            ),
            SizedBox(height: 8,),
            Expanded(
              child: _CardContents(event: event, offset: gauss, buildSkeleton: buildSkeleton,),
            )
          ],
        ),
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
}

class _CardContents extends StatelessWidget {

  final Event event;
  final double offset;
  final bool buildSkeleton;

  _CardContents({this.event, this.offset, this.buildSkeleton = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
      child: Transform.translate(
        offset: Offset(32 * offset, 0),
        child: (buildSkeleton)
          ? shimmerBox()
          : ListTile( 
              title: Text(event.name, style: TextStyle(fontSize: 20),),
              subtitle: Text(event.getFormattedDate()),
            )
      )
    );
  }
}

Widget shimmerBox({double  height}) {
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