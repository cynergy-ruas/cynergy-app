import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class LoginAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  static LoginAuth instance;

  Future<String> login(
      {@required String email, @required String password}) async {
    /*
    Uses firebase to log the user in using email and password.

    Args:
      email (String): The email id of the user.
      password (String): The password.

    Returns:
      String: The uid of the user.

    Raises:
      PlatformException: if the entered email and/or password is ""
    */

    if (email == "" || password == "") throw PlatformException;

    _currentUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _currentUser.uid;
  }

  Future<void> logout() async {
    /*
    Signs the user out.

    Returns:
      void
    */
    _currentUser = null;
    await _firebaseAuth.signOut();
  }

  Future<bool> isLoggedIn() async {
    /*
    Checks if the user is logged in.

    Returns:
      bool: true, if the user is logged in, false otherwise.
    */

    try {
      _currentUser = await _firebaseAuth.currentUser();
      return (_currentUser == null) ? false : true;
    } catch (e) {
      return false;
    }
  }

  static LoginAuth getInstance() {
    /*
    Gets the existing instance of this class. if not present, creates it.

    Returns:
      LoginAuth: The instance of this class.
    */

    if (instance == null) {
      instance = LoginAuth();
    }
    return instance;
  }

  Future<Map<String, dynamic>> getClaims() async {
    /*
    Parses the claims in the login token.

    Returns:
      Map<String, dynamic>: The claims.
    */

    String token = await _currentUser.getIdToken();
    return _parseJwt(token);
  }

  Map<String, dynamic> _parseJwt(String token) {
    /*
    Parses the JWT token.

    Args:
      token (String): The token to parse.

    Returns:
      Map<String, dynamic> The parsed token as a Map object.
    */

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
    /*
    Decodes a base 64 string.
    
    Args:
      str (String): The string to decode.

    Returns:
      String: The decoded string.

    Raises:
      Exception: When the input string is an invalid base 64 url.
    */
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
