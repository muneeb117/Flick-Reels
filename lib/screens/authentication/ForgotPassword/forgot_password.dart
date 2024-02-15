// import 'package:flick_reels/components/reusable_button.dart';
// import 'package:flick_reels/screens/authentication/ForgetPassword/bloc/forget_bloc.dart';
// import 'package:flick_reels/screens/authentication/ForgetPassword/bloc/forget_states.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../components/reusable_text.dart';
// import './bloc/forget_events.dart';
// import '../components/build_text_field.dart';
//
// class ForgetPassword extends StatelessWidget {
//   const ForgetPassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ForgetBloc, ForgetState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           body: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 50.h,
//                 ),
//                 auth_reusable_text('Forgot \nPassword'),
//                  SizedBox(
//                   height: 50.h,
//                 ),
//                 BuildTextField(
//                     text: 'New Password',
//                     textType: TextInputType.text,
//                     iconName: 'lock',
//                     onValueChange: (value) {
//                       context
//                           .read<ForgetBloc>()
//                           .add(PasswordEvent(value)); // Dispatch email event
//                     }),
//                  SizedBox(
//                   height: 20.h,
//                 ),
//                 BuildTextField(
//                     text: 'Confirm Password',
//                     textType: TextInputType.text,
//                     iconName: 'lock',
//                     onValueChange: (value) {
//                       context
//                           .read<ForgetBloc>()
//                           .add(RePasswordEvent(value)); // Dispatch email event
//                     }),
//                  SizedBox(
//                   height: 40.h,
//                 ),
//                 ReusableButton(text: 'Verify',onPressed: (){
//                   context.read<ForgetBloc>().add(SubmitNewPasswordEvent());
//
//
//                 },)
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/utils/toast_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/name.dart';
import '../components/build_text_field.dart';
import '../components/reusable_text.dart';

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
