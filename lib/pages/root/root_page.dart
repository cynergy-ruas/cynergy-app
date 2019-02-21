import 'package:cynergy_app/pages/qr/qrCore.dart';
import 'package:cynergy_app/utils/qrHandler/qrHandler.dart';
import "package:flutter/material.dart";
import "login_segment.dart";
import "../../utils/auth/login_auth.dart";
import "../../utils/db/database.dart";
import "../../utils/user/user.dart";
import "home_segment.dart";

class RootPage extends StatefulWidget{
  final LoginBaseAuth auth;
  final BaseDB db;

  RootPage({this.auth, this.db});
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
    User.ifSignedIn().then((res){
      setState((){
        _authStatus = !res ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        print("AUTHENTICATION STATUS: $_authStatus");
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
          onSignedIn: _signedIn,);
      case AuthStatus.signedIn:
        // return new HomePage(
        //   onSignedOut: _signedOut,
        // );
        return QrCore(qrHandler: QrHandler(db: widget.db), onSignOut: _signedOut,);
    }
    return null;
  }
}