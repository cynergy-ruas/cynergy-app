import "dart:async";
import "package:firebase_auth/firebase_auth.dart";

abstract class LoginBaseAuth{
  Future<String> logInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements LoginBaseAuth{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> logInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null)
      return user.uid;
    return null;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }
}