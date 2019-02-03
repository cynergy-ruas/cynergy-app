import "package:flutter/material.dart";
import "../../utils/user/user.dart";

class HomePage extends StatefulWidget {
  
  final VoidCallback onSignedOut;

  HomePage({this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _signOut() async{
    try{
      await User.logout();
      widget.onSignedOut();
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Sign out", style: new TextStyle(fontSize: 17, color: Colors.white)),
            onPressed: _signOut
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text("Welcome\nType:${User.type}", style: new TextStyle(fontSize: 32.0),),
        )
      ),
    );
  }
}