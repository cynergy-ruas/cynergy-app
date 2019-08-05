import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LoginAuth {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _currentUser;

  Future<String> authenticate({@required String email, @required String password,}) async {
    if (email == "" || password == "") {
      throw PlatformException;
    }

    _currentUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _currentUser.uid;
  }

  Future<void> deauthenticate()async{
    _currentUser = null;
    return await _firebaseAuth.signOut();
  }

  Future<String> getCurrentUser()async{
    try {
      _currentUser = await _firebaseAuth.currentUser();
      return _currentUser.uid;
    } catch (e){
      return null;
    }
  }

  Future<Map<String, dynamic>> getClaims() async{
    print(_currentUser);
    String token = await _currentUser.getIdToken();
    return _parseJwt(token);
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}