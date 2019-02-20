import "package:cloud_firestore/cloud_firestore.dart";
import 'package:meta/meta.dart';

abstract class BaseDB{
  void createUser(String uuid, String type);
  Future<String> getUserType(String uuid);
  Future<bool> addEventForUser({@required String userEmail, @required String event});
}

class FireStoreDB implements BaseDB{

  Firestore firestore = Firestore.instance;

  @override
  void createUser(String uuid, String type) async{
    DocumentReference doc = firestore.collection("users").document(uuid);
    doc.setData({"type":type});
    print("document created.");
  }

  @override
  Future<String> getUserType(String uuid) async{
    DocumentSnapshot doc = await firestore.collection("users").document(uuid).get();
    print("document retrieved");
    return doc.data["type"].toString();
  }

  @override
  Future<bool> addEventForUser({@required String userEmail, @required String event}) async{
    CollectionReference coll =  firestore.collection("Users").document(userEmail).collection("events_attended");
    DocumentReference doc = coll.document(event);
    doc.setData({"attended": true});
    return true;
  }

}
