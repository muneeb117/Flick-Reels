
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';

GestureDetector buildContinueButton(Function()?press) {
  return GestureDetector(
    onTap: press,
    child: Container(
      height: 25.h,
      width: 65.w,
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: AppColors.primaryBackground
                .withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child:const Center(
        child: Text(
          textAlign: TextAlign.center,
          'Continue',
          style: TextStyle(
            color: AppColors
                .primarySecondaryBackground,
          ),
        ),
      ),
    ),
  );
}