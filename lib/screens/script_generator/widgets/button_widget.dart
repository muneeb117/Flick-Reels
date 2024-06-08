import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GestureDetector defaultButton({
  Function()? onTap,
  required Color color,
  required String text,
  required Color labelColor,
  bool isSelected = false,  // To indicate if the template is selected
  IconData? icon,  // Optional icon

}) {
  return GestureDetector(
    onTap: onTap,
    child: Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 45.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: labelColor), // Show icon if it's not null
              if (icon != null) SizedBox(width: 10.w), // Space between icon and text
              Text(
                isSelected?'Template Selected':
                text,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

  );
}
