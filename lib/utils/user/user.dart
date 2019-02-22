import '../auth/login_auth.dart';
import '../db/database.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class User{
  static LoginBaseAuth _auth = new Auth();
  static BaseDB _db = new FireStoreDB();
  static Map<String, dynamic> _info;

  static Future<String> login(String email, String password) async{
    String userID = await _auth.logInWithEmailAndPassword(email, password);

    // if (userID != null){
    //   String type = await _db.getUserType(userID);

    //   _info = new Map<String, dynamic>();
    //   _info['uid'] = userID;
    //   _info['email'] = email;
    //   _info['type'] = type;

    //   final file = await _localFile;
    //   file.writeAsString(json.encode(_info), flush: true);
    // }
    
    return userID;
  }
  
  static Future<String> register(String email, String password) async{
    String userID = await _auth.createUserWithEmailAndPassword(email, password);
    
    // if (userID != null){
    //   _db.createUser(userID, "normal");

    //   _info = new Map<String, dynamic>();
    //   _info['uid'] = userID;
    //   _info['email'] = email;
    //   _info['type'] = "normal";

    //   final file = await _localFile;
    //   file.writeAsString(json.encode(_info), flush: true);

    // }
    return userID;
  }

  static Future<void> logout() async{
    await _auth.signOut();
  }

  // static Future<void> load() async{
  //   final file = await _localFile;
  //   String contents = file.readAsStringSync();

  //   _info = json.decode(contents);
  // }

  static Future<bool> ifSignedIn() async{
    String uid = await _auth.currentUser();
    if (uid == null){
      return false;
    }
    // await load();
    return true;
  }

  // static String get id{
  //   return _info["uid"];
  // }

  // static String get email{
  //   return _info["email"];
  // }

  // static String get type{
  //   return _info["type"];
  // }

  // static Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // static Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/user.json');
  // }


}