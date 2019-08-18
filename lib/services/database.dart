import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Database _instance;
  static Firestore _firestore;


  Future<List<Map<String, dynamic>>> getRecentEvents({@required int count}) async {
    /**
     * Gets the [count] number of recent events.
     * 
     * Args:
     *  count (int): The number of events to get.
     * 
     * Return:
     *  List<Map<String, dynamic>>: List containing the raw event data, null if
     *  error occurs.
     */

    List<Map<String, dynamic>> data = [];
    try{
      // getting a reference to the collection in firestore
      CollectionReference coll = _firestore.collection("EventsList");
      // getting the documents in the reference and ordering by date
      QuerySnapshot snapshot = await coll.orderBy("date", descending: true).limit(count).getDocuments();
      // adding the data in each document obtained to [data]
      snapshot.documents.forEach((doc) {
        Map<dynamic, dynamic> docData = doc.data;
        docData["docRef"] = doc.documentID;
        data.add(docData);
      });
      // returning data
      return data.reversed.toList();
    }
    catch (e) {
      return null;
    }
  }


  static Future<Database> getInstance() async {
    /**
     * Returns the created instance of this class. Also performs
     * some initialization.
     * 
     * Returns:
     *  Database: Instance of this class
     */
    if (_instance == null) {
      Firestore().settings(timestampsInSnapshotsEnabled: true);
      _instance = Database();
      _firestore = Firestore.instance;
    }

    return _instance;
  }
}