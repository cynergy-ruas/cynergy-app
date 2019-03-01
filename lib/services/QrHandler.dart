import 'package:barcode_scan/barcode_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'package:cynergy_app/services/Database.dart';

class QrHandler{

  final Database db;

  QrHandler({@required this.db}):
      assert(db != null);


  Future<void> _requestPermission()async{
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future<String> scan() async{
    try {
      String result = await BarcodeScanner.scan();
      return result;

    } on PlatformException catch (e){
      if (e.code == BarcodeScanner.CameraAccessDenied)
        _requestPermission();
      else
        return null;
    }
    return null;
  }

  Future<List<String>> processScanResults(String result) async{
    List<String> parts = result.split("/");
    if(await db.addEventForUser(userEmail: parts[0], event: parts[1]))
      return parts;
    return null;
  }
}