import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GestureDetector buildScriptButton({Function()? onTap, required final Color color,
    required final String text, required final Color labelColor}) {
  return GestureDetector(
    onTap: onTap,
    // onTap: () {

    // },
    child: Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 45.h,
        width: double.infinity,
        decoration: BoxDecoration(

          gradient: LinearGradient(colors:
          [
            color,
            Colors.purple,
          ]

          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: labelColor,
            fontSize: 16,
          ),
        )),
      ),
    ),
  );
}
