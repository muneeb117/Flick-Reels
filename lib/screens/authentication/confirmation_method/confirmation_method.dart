import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
class ConfirmationMethod extends StatefulWidget {
  const ConfirmationMethod({super.key});

  @override
  State<ConfirmationMethod> createState() => _ConfirmationMethodState();
}

class _ConfirmationMethodState extends State<ConfirmationMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(
                      top: 110.h,left: 20.w,right: 20.w
                  ),
                  height: 200.h,
                  width: 200.w,
                  child: SvgPicture.asset('assets/confirmation_screen.svg')),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){},
              child: Container(
                height: 100.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30),
                  border:Border.all(color: AppColors.primaryBackground),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primaryBackground,
                      ),
                        child: SvgPicture.asset("assets/chat.svg")),
                    Text.rich(
                        TextSpan(
                        children: [
                          TextSpan(
                            text: 'fdf'
                          ),
                          TextSpan(
                              text: 'fdf'
                          ),
                        ]
                    ))


                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
