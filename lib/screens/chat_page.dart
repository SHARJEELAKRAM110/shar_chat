import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shar_chat/components/chat_bubble.dart';
import 'package:shar_chat/components/my_text_field.dart';
import 'package:shar_chat/services/Chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receviverUserEmail;
  final String receviverUserID;
  final String receviverUserName;

  const ChatPage(
      {super.key,
      required this.receviverUserEmail,
      required this.receviverUserID,
        required this.receviverUserName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sandMessage() async {
    //only sand message if there is someting to sand
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sandMessage(
          widget.receviverUserID, _messageController.text);
      //clear the cotroller after sanding the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          widget.receviverUserName,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder(
            stream: _chatServices.getMessages(widget.receviverUserID,_firebaseAuth.currentUser!.uid),
            builder: ( context,snapshot) {
              if(snapshot.hasError){
                return Text("Error");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Text("Loading...");
              }
              return ListView(
                children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                  controller: _messageController,
                  hintText: 'Enter Message',
                  obscureText: false,
                )),
                //Sand Buton
                IconButton(onPressed: sandMessage, icon: Icon(Icons.arrow_upward,size: 40,))
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic>data=document.data() as Map<String ,dynamic>;
    //allign the messages
    var alignment=(data["sanderId"]==_firebaseAuth.currentUser!.uid)?Alignment.centerRight:Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data["sanderId"]==_firebaseAuth.currentUser!.uid)?CrossAxisAlignment.end:CrossAxisAlignment.start,
          mainAxisAlignment: (data["sanderId"]==_firebaseAuth.currentUser!.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            // Text(data["sanderEmail"]),
            ChatBubble(message: data["message"]),
          ],
        ),
      ),
    );
  }
}
