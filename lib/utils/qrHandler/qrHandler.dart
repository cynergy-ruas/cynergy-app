
import 'package:cynergy_app/utils/db/database.dart';
import 'package:meta/meta.dart';

class QrHandler{
  final BaseDB db;
  QrHandler({@required this.db}):
    assert(db != null);

  Future<bool> handle({@required String email, @required String event})async{
    try{
      return await db.addEventForUser(userEmail: email, event: event);
    }
    catch(error){
      return false;
    }
  }
}