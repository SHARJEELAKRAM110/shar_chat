import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUploadImageContainer extends StatelessWidget {
  double height;
  double width;
  VoidCallback? onTap;
  File? image;

  CustomUploadImageContainer(
      {Key? key, this.height = 105, this.width = 150, this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height.h,
        width: width.w,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: image == null
                  ? Image.asset(
                      "assets/images/uploadIcon.png",
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image!,
                        height: height.h,
                        width: width.w,
                        fit: BoxFit.fill,
                      ),
                    )),
        ),
      ),
    );
  }
}
