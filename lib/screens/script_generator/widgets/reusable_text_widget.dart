import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class reusable_scipt_text extends StatelessWidget {
  const reusable_scipt_text({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(
        text,
        style:  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}
