import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color? color;
  final void Function()?onTap;
  const MyButton({super.key, this.onTap, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(text,style: TextStyle(color: Color(0xff000000),fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
