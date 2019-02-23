import 'package:cynergy_app/services/LoginAuth.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final LoginAuth auth;

  UserRepository({@required this.auth}):
      assert(auth != null);

  Future<String> login({@required String email, @required String password,}) async {
    String uid = await auth.authenticate(email: email, password: password);
    return uid;
  }

  Future<void> logout() async {
    await auth.deauthenticate();
  }

  Future<bool> isLoggedIn() async{
    String uid = await auth.getCurrentUser();
    if (uid != null)
      return true;
    return false;
  }

  bool isCoordinator(){
    return auth.getClaim("coordinator");
  }
}