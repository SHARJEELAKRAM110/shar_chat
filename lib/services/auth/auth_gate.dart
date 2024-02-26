import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shar_chat/services/auth/login_or_rigister.dart';
import '../../screens/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder:(context,snapshot){
          if(snapshot.hasData){
            return HomePagee();
          }else{
            return LoginOrRegister();
          }
        } ,
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
