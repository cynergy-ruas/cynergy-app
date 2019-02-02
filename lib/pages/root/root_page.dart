import "package:flutter/material.dart";
import "login_segment.dart";
import "../../auth/login_auth.dart";
import "home_segment.dart";

class RootPage extends StatefulWidget{
  final LoginBaseAuth auth;

  RootPage({this.auth});
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  signedIn,
  notSignedIn
}

class _RootPageState extends State<RootPage>{

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userID) {
      setState(() {
        _authStatus = userID == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
        _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
        _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context){
    switch(_authStatus){
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,);
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
    return null;
  }
}