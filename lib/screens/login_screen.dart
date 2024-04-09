import 'package:SharChat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:SharChat/components/my_button.dart';
import 'package:SharChat/components/my_text_field.dart';
import 'package:SharChat/services/auth/auth_services.dart';

import '../google_signin/Authentication.dart';

class LoginScreen extends StatefulWidget {
  final void Function()?onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
String passwordStrength="";
checkPasswordStrength(String value){
  if(value.isEmpty){
    return "Enter atleast Eight Character password!";
  }else if(value.length<8){
    return "Password is week";
  } else{
    return "Strong Password";
  }
}
class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final nameController=TextEditingController();
  bool show=true;
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellowAccent
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage("assets/images/notImage.png"),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Welcome back you\'ve been missed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                SizedBox(height: 20,),
                TextFormField(

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
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                      suffixIcon: Visibility(
                        visible: emailShow,
                        child: Icon(
                          Icons.done,
                        ),
                      ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: "Email",

                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),

                  ),

                ),
                SizedBox(height: 20,),
                MyTextField(controller: passwordController,
                    onChanged: (value){
                  setState(() {
                    passwordStrength=checkPasswordStrength(value);

                  });
                    },

                    hintText: "password",
                    obscureText: show,
                  onIconTap: (){
                  setState(() {
                    show=!show;
                  });
                  },
                  icon:show? Icons.visibility:Icons.visibility_off,
                ),
                SizedBox(height: 5,),
                Container(height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(passwordStrength.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontStyle: FontStyle.italic,color: passwordStrength=="Enter atleast Eight Character password!"||passwordStrength=="Password is week"?Colors.red:Colors.green),),
                    ),
                  ],
                ),
                ),
                SizedBox(height: 5,),

                MyButton(text: "Sign In", onTap: signIn,color: Colors.yellowAccent,),
                SizedBox(height: 10,),
                Container(
                  width: 320,
                  height: 70,
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Authentication.signInWithGoogle(context: context);
                      print("google sign tapped");
                    },
                    icon: Icon(Icons.g_mobiledata_rounded),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                    ),
                  ),
                ),
                SizedBox(height: 50,),


                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?",style: TextStyle(color: Colors.white),),
                  SizedBox(width: 4,),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Register Now",style: TextStyle(color: Colors.yellowAccent),))
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
