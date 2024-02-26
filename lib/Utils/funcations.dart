import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

void customSnackBar(String title,String message){
  Get.snackbar(title,message);
}
customLoading(){
  Get.defaultDialog(
    backgroundColor: Colors.transparent,
    title: "",
    content: WillPopScope(
        onWillPop: () => Future.value(false),
        child:const SpinKitWaveSpinner(
          color: Colors.red,
        )
    ),
  );



}
