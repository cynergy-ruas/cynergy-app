import 'package:cynergy_app/widgets/profile_drawer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ProfileDrawer(),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 100,
            right: 0,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  color: Colors.white
                ),
                child: Icon(Icons.settings, color: Colors.black, size: 40,),
              ),
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            )
          ),
          Center(
            child: Text("Profile Page"),
          )
        ],
      ),
    );
  }
}