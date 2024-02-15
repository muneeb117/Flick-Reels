
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';

class buildRowField extends StatelessWidget {
  buildRowField({
    required this.title,
    required this.subtitle,
    super.key, this.onTap,
  });
  String title;
  String subtitle;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,style: TextStyle(
            fontSize: 14.sp,
          ),),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: onTap,
            child: Text(subtitle,style: TextStyle(
              color: AppColors.primaryBackground,
              fontSize: 14.sp,
            ),),
          ),
        ],
      ),
    );
  }
}

