import "package:flutter/material.dart";
import "../../utils/user/user.dart";

class HomePage extends StatefulWidget {
  
  final VoidCallback onSignedOut;

  HomePage({this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   final navbarColor=const Color(0xFF1c2331);
  final titleColor=Color.fromARGB(255,222,63,15);

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
        title: new Text("Welcome",style: TextStyle(color: titleColor),),
        backgroundColor: navbarColor,
        actions: <Widget>[
          new FlatButton(
            child: new Text("Sign out", style: new TextStyle(fontSize: 17, color: Colors.white)),
            onPressed: _signOut
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text("Welcome", style: new TextStyle(fontSize: 32.0),),
        )
      ),
    );
  }
}