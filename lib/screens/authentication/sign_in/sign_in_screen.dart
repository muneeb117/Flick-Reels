import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_events.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_states.dart';
import 'package:flick_reels/screens/authentication/sign_in/controller/sign_in_controller.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/loading_indicator.dart';
import '../../../routes/name.dart';
import 'package:get/get.dart';

import '../widgets/build_text_field.dart';
import '../widgets/divider.dart';
import '../widgets/reusable_text.dart';
import '../widgets/row_field.dart';
import '../widgets/third_party_plugins.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   final loadingController = Get.put(LoadingController());
   @override
   void initState() {
     super.initState();
     context.read<SignInBloc>().add(SignInResetEvent());
   }


   @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
      return Scaffold(
        body: Obx(() {
          if (loadingController.isLoading.value) {
            // Show loading indicator when loading is true
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                    ),
                    auth_reusable_text('Sign In'),
                    SizedBox(
                      height: 50.h,
                    ),
                    BuildTextField(
                        text: 'Email',
                        textType: TextInputType.emailAddress,
                        iconName: 'inbox',
                        onValueChange: (value) {
                          context
                              .read<SignInBloc>()
                              .add(EmailEvents(value)); // Dispatch email event
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    BuildTextField(
                        text: 'Password',
                        textType: TextInputType.text,
                        iconName: 'lock',
                        onValueChange: (value) {
                          context
                              .read<SignInBloc>()
                              .add(
                              PasswordEvents(value)); // Dispatch email event
                        }),
                    const SizedBox(
                      height: 40,
                    ),
                    ReusableButton(
                      text: 'Sign in',
                      onPressed: () {
                        SignInController(context: context).handleSignIn(
                            "email");
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgetPassword);
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 0, left: 220.w),
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                                color: AppColors.primaryBackground),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const buildDivider(
                      text: 'Or Login with',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildThirdParyPlugin(
                            iconPath: "assets/google.svg", onPressed: () {
                          GoogleAuthentication().signInWithGoogle(context);
                        }),
                        const SizedBox(
                          width: 50,
                        ),
                        buildThirdParyPlugin(
                            iconPath: "assets/facebook.svg", onPressed: () {
                          FacebookAuthentication().loginWithFacebook(context);
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildRowField(
                      title: "Don’t have an account?",
                      subtitle: "Sign up",
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.register);
                      },
                    )
                  ],
                ),
              ),
            );
          }
        }   ),
      );
    });
  }
}
