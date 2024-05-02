import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class ConfirmUploadButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final List<Color>? gradientColors; // For gradient effect
  final bool isEnabled; // Indicates if the button is enabled

  const ConfirmUploadButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradientColors, // Optional gradient colors
    this.isEnabled = true, // Button is enabled by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color startColor = gradientColors?.first ?? AppColors.primaryBackground;
    Color endColor = gradientColors?.last ?? AppColors.primaryBackground;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null, // Only allow tap if button is enabled
      child: Container(
        width: double.infinity,
        height: 45.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: startColor.withOpacity(0.5),
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
          ],
          gradient: isEnabled
              ? LinearGradient(colors: gradientColors ?? [startColor, endColor])
              : LinearGradient(colors: [Colors.grey, Colors.grey]),
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
