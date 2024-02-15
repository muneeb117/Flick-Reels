
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/utils/toast_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/name.dart';
import '../widgets/build_text_field.dart';
import '../widgets/reusable_text.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150.h,
            ),
            auth_reusable_text('Forget\nPassword'),
            SizedBox(
              height: 50.h,
            ),
            BuildTextField(
              text: "Email", textType: TextInputType.emailAddress,
              iconName: 'inbox',
              onValueChange: (value){
                emailController.text=value.toString();
              },

            ),
            const SizedBox(
              height: 40,
            ),
            ReusableButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );
                  toastInfo(msg: "Password reset email sent",context: context);
                  Navigator.pushNamed(context, AppRoutes.forgetNotification);

                } catch (e) {
                  // Handle errors
                  toastInfo(msg: "Error: ${e.toString()}",context: context);
                }
              },
              text:"Reset Password"
            ),
          ],
        ),
      ),
    );
  }
}
