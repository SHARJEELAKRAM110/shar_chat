import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:SharChat/services/auth/auth_services.dart';
import '../services/Chat/chat_services.dart';
import 'chat_page.dart';

class HomePagee extends StatefulWidget {
  final XFile? selectedImageFile;


  const HomePagee({super.key, this.selectedImageFile});

  @override
  State<HomePagee> createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  XFile? _selectedImage;

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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
              ),
              child: _selectedImage != null
                  ? CircleAvatar(
                backgroundImage: FileImage(File(_selectedImage!.path)),
                radius: 50,
              )
                  : Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home,color: Colors.black,size: 26,),
                      SizedBox(width: 10,),
                      Text("Home",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                    ],
                  ),
                  Icon(Icons.navigate_next,color: Colors.black,size: 28,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: signOut,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.logout,color: Colors.black,size: 26,),
                        SizedBox(width: 10,),
                        Text("logout",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                      ],
                    ),
                    Icon(Icons.navigate_next,color: Colors.black,size: 28,),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu, // Use your custom icon here
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer when tapped
              },
            );
          },
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("SharChat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 24),),
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
  // build individual user list item
Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data=document.data()! as Map<String ,dynamic>;

    //display all uses execpt current user
  if(_auth.currentUser!.email!=data["email"]){
    return Card(
      child: ListTile(
        title: Text(data["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
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
