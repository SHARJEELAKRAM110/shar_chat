import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()?onTap;
  const MyButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xff000000),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(text,style: TextStyle(color: Color(0xffFFFFFF),fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
