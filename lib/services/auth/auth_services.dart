

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/cupertino.dart';


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
// Upload image to Firebase Storage
  Future<String> uploadImage(String imagePath, String uid) async {
    try {
      // Get a reference to the storage service, using the default Firebase App
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(uid)
          .child('profile_image.jpg');

      // Upload the file to Firebase Storage
      await ref.putFile(File(imagePath));

      // Get the download URL
      String imageUrl = await ref.getDownloadURL();

      // Update the user document with the image URL
      await _firestore.collection("users").doc(uid).update({
        "profileImageUrl": imageUrl,
      });

      return imageUrl;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }


// Retrieve image URL from Firestore
  Future<String?> _getUserProfileImageURL(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      return (userDoc.data() as Map<String, dynamic>?)?['profileImageUrl'];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}





