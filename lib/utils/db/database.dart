import "package:cloud_firestore/cloud_firestore.dart";

abstract class BaseDB{
  void createUser(String uuid, String type);
  Future<String> getUserType(String uuid);
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

}
