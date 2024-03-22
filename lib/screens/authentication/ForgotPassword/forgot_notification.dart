import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../routes/name.dart';
import '../../../utils/colors.dart';

class ForgotNotificationScreen extends StatefulWidget {
  const ForgotNotificationScreen({super.key});

  @override
  _ForgotNotificationScreenState createState() => _ForgotNotificationScreenState();
}

class _ForgotNotificationScreenState extends State<ForgotNotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushNamed(context, AppRoutes.signIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,size: 20,),
          onPressed: (){
            Navigator.pushNamed(context, AppRoutes.signIn);
          },
        ),
        elevation: 0,
        title: Text("Password Reset",style: TextStyle(
          color: AppColors.primaryBackground,fontSize: 20
        ),),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h,),
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/email.png"),
                ),
              ),
              child: Lottie.asset("assets/json_animation/email_sent.json"),
            ),
            SizedBox(height: 30.h),
            Text(
              "Email has been Sent to Your Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryBackground,
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Please check your inbox and follow the instructions to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
