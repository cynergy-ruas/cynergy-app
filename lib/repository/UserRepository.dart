import 'dart:async';

import 'package:cynergy_app/services/LoginAuth.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final LoginAuth auth;
  Map<String, dynamic> _claims;

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
    if (uid != null) {
      await setClaims();
      return true;
    }
    return false;
  }

  Future<void> setClaims() async{
    _claims = await auth.getClaims();
  }

  String getEmailId(){
    return _claims["email"];
  }

  bool isCoordinator(){
    if (_claims["coordinator"] != null)
      return true;
    return false;
  }


}