

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shar_chat/Utils/funcations.dart';


class AuthServices extends ChangeNotifier{
  // instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  // instance of Auth
final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //Sign user in
  Future signInWithEmailAndPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
          email: email,
          password: password,
      );
//add a new document if it allready dont exist
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid":userCredential.user!.uid,
        "email":email,
      },SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }




//create a new user
  Future signUpWithEmailAndPassword(
      String email, String password,String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      //after creating user create a new document
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid":userCredential.user!.uid,
        "email":email,
        "name": name, // Add user's name

      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  //Sign user out
  Future<void>signOut()async{
    return await FirebaseAuth.instance.signOut();
  }


}





