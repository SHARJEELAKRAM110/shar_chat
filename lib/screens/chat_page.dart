import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:SharChat/components/chat_bubble.dart';
import 'package:SharChat/components/my_text_field.dart';
import 'package:SharChat/services/Chat/chat_services.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,size: 20,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.receviverUserName,
          style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                keyboardType: TextInputType.multiline,

                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 12), // Adjust the right padding as needed

                                  hintText: 'Type Something...',
                      border: InputBorder.none
                                ),
                            controller: _messageController,
                            obscureText: false,
                          )
                          ),
                          //Sand Buton
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: MaterialButton(onPressed: sandMessage,
                        shape: CircleBorder(),
                        color: Colors.yellowAccent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.send,size: 25,),
                        )),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic>data=document.data() as Map<String ,dynamic>;
    //allign the messages
    var alignment=(data["sanderId"]==_firebaseAuth.currentUser!.uid)?Alignment.centerRight:Alignment.centerLeft;
    // Convert the timestamp to DateTime
    DateTime messageTime = (data['timestamp'] as Timestamp).toDate();
    // Format the time to display
    String formattedTime =
        "${messageTime.hour}:${messageTime.minute}"; // You can customize the format as needed
    // Define the color based on the sender
    Color bubbleColor =
    (data["sanderId"] == _firebaseAuth.currentUser!.uid)
        ? Colors.blue
        : Colors.white24;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data["sanderId"]==_firebaseAuth.currentUser!.uid)?CrossAxisAlignment.end:CrossAxisAlignment.start,
          mainAxisAlignment: (data["sanderId"]==_firebaseAuth.currentUser!.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Text(
              formattedTime, // Display the formatted time
              style: TextStyle(
                color: Colors.grey, // You can customize the color
                fontSize: 12, // You can customize the font size
              ),
            ),
            // Text(data["sanderEmail"]),
            ChatBubble(message: data["message"], color: bubbleColor,),
          ],
        ),
      ),
    );
  }
}
