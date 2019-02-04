import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';


class QrCore extends StatefulWidget{
@override 
_QrCoreState createState() => new _QrCoreState();
} 

class _QrCoreState extends State<QrCore> {
   final navbarColor=const Color(0xFF1c2331);
  final titleColor=Color.fromARGB(255,222,63,15);
  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();
   
 String _reader='';
  Permission permission= Permission.Camera;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromARGB(255,3, 14, 29),
      home:new Scaffold(
        key: mScaffoldState,
        backgroundColor: navbarColor,
        appBar: new AppBar(title: new Text("Scanner",style: TextStyle(color: titleColor),),       
        backgroundColor: navbarColor),
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
              new Text('$_reader',softWrap: true, style: new TextStyle(fontSize: 30.0,color: Colors.blue),),
            
         ],
        ),
      ),
    );
  }
   requestPermission() async {
    PermissionStatus result = await SimplePermissions.requestPermission(permission);
    setState(()=> new SnackBar
    (backgroundColor: Colors.red,content: new Text(" $result"),),
    
    );
  }
  scan() async {
    try {
   String reader= await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }
      setState(() => this._reader=reader);
    } on PlatformException catch(e) {
     if(e.code==BarcodeScanner.CameraAccessDenied) {requestPermission();}
     else{final snackBar = new SnackBar(content: new Text('Unknown Exception $e'));
       setState(()=> mScaffoldState.currentState.showSnackBar(snackBar) );}
  }on FormatException{final snackBar1 = new SnackBar(content: new Text('Went back before scanning'));
      setState(() => mScaffoldState.currentState.showSnackBar(snackBar1)   );                        //_reader = "");
    } catch (e) {final snackBar2 = new SnackBar(content: new Text('Unknown Error $e'));
      setState(() =>  mScaffoldState.currentState.showSnackBar(snackBar2) );
    }
 
}

}

