import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:SharChat/services/auth/auth_services.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  final Function(XFile?)? onImageSelected; // Callback function for image selection
  const RegisterPage({super.key, this.onTap, this.onImageSelected});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController=TextEditingController();
  final nameController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  XFile?imageFile;
bool aShow=true;
bool emailShow=false;

  // Function to handle image selection
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        imageFile = XFile(pickedImage.path);
        widget.onImageSelected?.call(imageFile); // Call the callback function
      }
    });
  }


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
  if (imageFile != null) {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    await authService.uploadImage(imageFile!.path, currentUid);
  }
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
                  GestureDetector(
                    onTap: _pickImage, // Call the function when tapped
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellowAccent,
                      ),
                      child: imageFile != null
                          ? CircleAvatar(
                        backgroundImage: FileImage(File(imageFile!.path)),
                        radius: 70,
                      )
                          : Icon(
                        Icons.add_photo_alternate,
                        size: 70,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Let's create an account for you",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                  SizedBox(height: 20,),
              
                  MyTextField(controller: nameController,
                      textInputType: TextInputType.text,
                      hintText: "Name",
                      obscureText: false),
                  SizedBox(height: 20,),

                  TextFormField(
                      keyboardType:TextInputType.emailAddress,
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
                    textInputType: TextInputType.multiline,
                    onChanged: (value){
                      setState(() {
                        passwordStrength=checkPasswordStrength(value);

                      });
                    },

                    hintText: "password",
                    obscureText: aShow,
                    onIconTap: (){
                      setState(() {
                        aShow=!aShow;
                      });
                    },
                    icon:aShow? Icons.visibility:Icons.visibility_off,
                  ),
                  Container(height: 20,
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
              
                  MyTextField(controller: confirmPasswordController,
                      hintText: "Confirm password",
                      onIconTap: (){
                        setState(() {
                          aShow=!aShow;
                        });
                      },
                      icon:aShow? Icons.visibility:Icons.visibility_off,
                      obscureText: aShow),
                  SizedBox(height: 20,),


                  MyButton(text: "Sign up", onTap:singUp,color: Colors.yellowAccent,),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member?",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                      SizedBox(width: 4,),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text("Login Now",style: TextStyle(color: Colors.yellowAccent),))
                    ],
                  ),
                  SizedBox(height: 40,),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}