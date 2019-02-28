import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Database{
  Firestore _firestore = Firestore.instance;

  Future<bool> addEventForUser({@required String userEmail, @required String event}) async{
    print("user: $userEmail, event: $event");
    try {
      CollectionReference coll = _firestore.collection("Users").document(
          userEmail).collection("events_attended");
      DocumentReference doc = coll.document(event);
      await doc.setData({"attended": true});
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRecentEvents(int count)async{

    List<Map<String, dynamic>> data = [];
    try{
      CollectionReference coll = _firestore.collection("EventsList");
      QuerySnapshot snapshot = await coll.orderBy("date", descending: true).limit(count)
            .getDocuments();

      snapshot.documents.forEach((doc) => data.add(doc.data));
    }
    catch(e){
      return null;
    }
    return data;
  }
}