import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cynergy_app/utils/qrHandler/qrHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCore extends StatefulWidget{
  final QrHandler qrHandler;
  final VoidCallback onSignOut;

  QrCore({@required this.qrHandler, @required this.onSignOut}):
    assert(qrHandler != null),
    assert(onSignOut != null);

  @override 
  _QrCoreState createState() => new _QrCoreState();
} 

class _QrCoreState extends State<QrCore> {
  final navbarColor=const Color(0xFF1c2331);
  final titleColor=Color.fromARGB(255,222,63,15);
  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();
  
  QrHandler get _qrHandler =>widget.qrHandler;
  VoidCallback get _onSignOut => widget.onSignOut;
   
  String resultString='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromARGB(255,3, 14, 29),
      home:new Scaffold(
        key: mScaffoldState,
        backgroundColor: navbarColor,
        appBar: new AppBar(
          title: new Text("Scanner",style: TextStyle(color: titleColor)),       
          backgroundColor: navbarColor,
          actions: <Widget>[
            new FlatButton(
              child: new Text("Sign out", style: new TextStyle(fontSize: 17, color: Colors.white)),
              onPressed: _onSignOut
            )
          ],
        ),
        body: new Column(        
          children: <Widget>[   
            new Padding(padding: const EdgeInsets.only(
              top: 80,
              left: 0,
              right: 600,
              bottom: 200,
              )
            ),
            new RaisedButton(         
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),         
              elevation: 4,
              splashColor: Color.fromARGB(255,3, 14, 29),
              color: const Color.fromARGB(255,0, 22, 54),
              child: new Text("Scan",style: new TextStyle(fontSize: 20.0,color: Colors.white70),),
              onPressed: scan,
            ),
            new Padding(padding: const EdgeInsets.symmetric(vertical: 10.0), ),
            new Text('$resultString',softWrap: true, style: new TextStyle(fontSize: 30.0,color: Colors.blue),),
         ],
        ),
      ),
    );
  }
  
  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    setState(() =>
    new SnackBar(
      backgroundColor: Colors.red,
      content: new Text("camera permssion probably not granted"),
      ),
    );
  }

  scan() async {
    try {
      String reader= await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }

      List<String> parts = reader.split("/");
      bool res = await _qrHandler.handle(email: parts[0], event: parts[1]); 
      if (res){
      setState(() => this.resultString="Attendance taken!");
      }else{
        setState(() => this.resultString="Try again");
      } 

    } on PlatformException catch(e) {
      if(e.code==BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      }
      else{
        final snackBar = new SnackBar(content: new Text('Unknown Exception $e'));
        setState(()=> mScaffoldState.currentState.showSnackBar(snackBar) );
      }
    } on FormatException {
      final snackBar1 = new SnackBar(content: new Text('Went back before scanning'));
      setState(() => mScaffoldState.currentState.showSnackBar(snackBar1));                        //_reader = "");
    } catch (e) {
      final snackBar2 = new SnackBar(content: new Text('Unknown Error $e'));
      setState(() =>  mScaffoldState.currentState.showSnackBar(snackBar2));
    }
  }
}

