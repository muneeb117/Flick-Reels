import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class See_All extends StatelessWidget {
  const See_All({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'See All',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
            height: 20,
            width: 20,
            child: Image.asset("assets/right-arrow.png")),
      ],
    );
  }
}
