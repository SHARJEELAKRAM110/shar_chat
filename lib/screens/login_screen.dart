import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shar_chat/components/my_button.dart';
import 'package:shar_chat/components/my_text_field.dart';
import 'package:shar_chat/services/auth/auth_services.dart';

class LoginScreen extends StatefulWidget {
  final void Function()?onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final nameController=TextEditingController();
  bool show=false;
  bool emailShow=false;
  Future<void> signIn() async {
final authService=Provider.of<AuthServices>(context,listen: false);
try{
  await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
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
                Text("Welcome back you\'ve been missed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                SizedBox(height: 20,),
              
                MyTextField(controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        emailShow = GetUtils.isEmail(value);
                      });
                    },
                    hintText: "Email",
                 obscureText: false),
                SizedBox(height: 20,),
                MyTextField(controller: passwordController,

                    hintText: "paswword",
                    obscureText: show,
                  onIconTap: (){
                  setState(() {
                    show=!show;
                  });
                  },
                  icon:show? Icons.visibility:Icons.visibility_off,
                ),
                SizedBox(height: 25,),
                MyButton(text: "Sign In", onTap: signIn,),
                SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?"),
                  SizedBox(width: 4,),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Register Now"))
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
