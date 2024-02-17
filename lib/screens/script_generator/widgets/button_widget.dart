import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GestureDetector buildScriptButton(Function()? onTap, final Color color,
    final String text, final Color labelColor) {
  return GestureDetector(
    onTap: onTap,
    // onTap: () {

    // },
    child: Center(
      child: Container(
        height: 35.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: labelColor,
            // color:
          ),
        )),
      ),
    ),
  );
}
