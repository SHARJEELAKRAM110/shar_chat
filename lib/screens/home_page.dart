import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shar_chat/services/auth/auth_services.dart';
import '../services/Chat/chat_services.dart';
import 'chat_page.dart';

class HomePagee extends StatefulWidget {

  const HomePagee({super.key});

  @override
  State<HomePagee> createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  final ChatServices chatService = ChatServices();
  //instance of auth
  final FirebaseAuth _auth=FirebaseAuth.instance;
  void signOut() {
    final authService=Provider.of<AuthServices>(context,listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("SharChat",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context,snapshot) {
          if(snapshot.hasError){
            return Text("error");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Loading...");
          }
          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          );
        },
      ),
    );
  }
  //build individual user list item
Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data=document.data()! as Map<String ,dynamic>;

    //display all uses execpt current user
  if(_auth.currentUser!.email!=data["email"]){
    return Card(
      child: ListTile(
        title: Text(data["name"]),
        onTap: (){
          Get.to(ChatPage(receviverUserEmail: data["email"], receviverUserID:data["uid"],receviverUserName: data["name"],));
        },
      ),
    );
  }else{
    return Container();
  }
}
}
