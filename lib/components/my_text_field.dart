import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon; // Optional icon
  final TextInputType? textInputType;
  final VoidCallback? onIconTap; // Callback for icon tap
  final ValueChanged<String>? onChanged; // Optional onChanged callback
  final String? Function(String?)? validator; // Optional validator function


  const MyTextField({super.key, required this.controller, required this.hintText, required this.obscureText, this.icon, this.onIconTap, this.onChanged, this.validator, this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
keyboardType:textInputType,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
          suffixIcon: icon != null
              ? GestureDetector(
            onTap: onIconTap,
            child: Icon(icon),
          )
              : null,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),

      ),
      validator: validator, // Assigning validator function

    );
  }
}
