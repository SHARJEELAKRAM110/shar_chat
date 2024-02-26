
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shar_chat/services/auth/auth_services.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()?onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController=TextEditingController();
  final nameController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  XFile?imageFile;





  Future<void> singUp() async {
if(passwordController.text!=confirmPasswordController.text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password do not Match"))
  );
  return;
}
//get auth service
  final authService=Provider.of<AuthServices>(context,listen: false);
try{
  await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text,nameController.text);
}catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message,size: 100,),
                  SizedBox(height: 20,),
                  Text("Let's create an account for you",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  SizedBox(height: 20,),
              
                  MyTextField(controller: nameController,
                      hintText: "Name",
                      obscureText: false),
                  SizedBox(height: 20,),

                  MyTextField(controller: emailController,
                      hintText: "Email",
                      obscureText: false),
                  SizedBox(height: 20,),
                  MyTextField(controller: passwordController,
                      hintText: "password",
                      obscureText: true),
                  SizedBox(height: 20,),
              
                  MyTextField(controller: confirmPasswordController,
                      hintText: "Confirm password",
                      obscureText: true),
                  SizedBox(height: 20,),


                  MyButton(text: "Sign up", onTap:singUp,),
                  SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member?"),
                      SizedBox(width: 4,),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text("Login Now"))
                    ],
                  )
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
