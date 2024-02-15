

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Padding auth_reusable_text(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40.sp,
      ),
    ),
  );
}
