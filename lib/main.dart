
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'package:shar_chat/services/auth/auth_gate.dart';
import 'package:shar_chat/services/auth/auth_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      child: const MyApp(),
      create: (context)=>AuthServices()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
     debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}


