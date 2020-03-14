import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:foody/models/user.dart';
import '../services/database.dart';

class AuthService  {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService dbService = DatabaseService();
  User _userFromFirebaseUser(FirebaseUser user)  {

    return user != null ? User(uId: user.uid) : null;
  }

  //Mail ve Parola ile giriş
  Future signInEmail(LoginData logindata) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: logindata.name, password: logindata.password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Kullanıcı Auth değişimini dinliyor
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //register email pass
  Future signUpEmail(LoginData loginData) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: loginData.name, password: loginData.password);
      FirebaseUser user = result.user;
      dbService.createUserProfile(user.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
