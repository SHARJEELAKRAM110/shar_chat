import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shar_chat/Models/message.dart';

class ChatServices extends ChangeNotifier {

  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Sand Message
  Future<void> sandMessage(String recevierId, String message) async {
    //Get Current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //Create a new message
    Message newMessage = Message(
        sanderId: currentUserId,
        sanderEmail: currentUserEmail,
        receiverId: recevierId,
        message: message,
        timestamp: timestamp,
    );

    //Construct Chat room id
List<String>ids=[currentUserId,recevierId];
ids.sort();
String chatRoomId=ids.join("_");

    //add new message to database
    await _firestore.collection("chat_room").doc(chatRoomId).collection("messages").add(newMessage.toMap());
  }

// Get Message
Stream<QuerySnapshot> getMessages(String userId,String otherUser){
    List<String> ids=[userId,otherUser];
    ids.sort();
    String chatRoomId=ids.join("_");
    return _firestore.collection("chat_room").doc(chatRoomId).collection("messages").orderBy("timestamp",descending: false).snapshots();
}
}