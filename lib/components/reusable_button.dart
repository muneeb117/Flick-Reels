import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? buttonColor; // Optional color override
  final bool isEnabled; // Indicates if the button is enabled

  const ReusableButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.buttonColor, // Allow passing a color
    this.isEnabled = true, // Button is enabled by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null, // Only allow tap if button is enabled
      child: Container(
        width: double.infinity,
        height: 45.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: AppColors.primaryBackground.withOpacity(0.5),
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
          ],
          color: isEnabled ? (buttonColor ?? AppColors.primaryBackground) : Colors.grey, // Use grey if disabled
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.primarySecondaryBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
