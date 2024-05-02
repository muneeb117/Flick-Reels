import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
class UploadButton extends StatelessWidget {
  final Function()? onPressed;

  const UploadButton({
    super.key, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPressed ,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: 45.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.strokeColor),
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Upload',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600),),
            SizedBox(width: 5,),
            Icon(Icons.upload_rounded)
          ],
        ),
      ),
    );
  }
}
