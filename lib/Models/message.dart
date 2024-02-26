import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String sanderId;
  final String sanderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  Message({
    required this.sanderId,
    required this.sanderEmail,
    required this.receiverId,
    required this.message,
      required this.timestamp
  });
//convert to map
Map<String , dynamic>toMap(){
  return {
    "sanderId":sanderId,
    "sanderEmail":sanderEmail,
    "receiverId":receiverId,
    "message":message,
    "timestamp":timestamp,
  };
}

}