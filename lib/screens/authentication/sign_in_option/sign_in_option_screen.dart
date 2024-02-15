import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/screens/rules_privacy/community_guidlines.dart';
import 'package:flick_reels/screens/rules_privacy/privacy_policy.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/loading_indicator.dart';
import '../../../routes/name.dart';
import 'package:get/get.dart';

import '../widgets/divider.dart';
import '../widgets/row_field.dart';
import '../widgets/third_party_plugins.dart';

class SignInOptionScreen extends StatelessWidget {
  SignInOptionScreen({super.key});
  final LoadingController loadingController =
      Get.put(LoadingController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          if (loadingController.isLoading.value) {
            // Show loading indicator when loading is true
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 20.h, left: 30.w),
                      height: 200.h,
                      width: 200.w,
                      child: SvgPicture.asset('assets/sign_in_option.svg')),
                ),
                const SizedBox(
                  height: 30,
                ),
                third_party_main(
                  onTap: () {
                    FacebookAuthentication().loginWithFacebook(context);
                  },
                  text: 'Continue with Facebook',
                  imagePath: 'assets/facebook.svg',
                ),
                SizedBox(
                  height: 20.h,
                ),
                third_party_main(
                  onTap: () {
                    GoogleAuthentication().signInWithGoogle(context);
                  },
                  text: 'Continue with Google',
                  imagePath: 'assets/google.svg',
                ),
                SizedBox(height: 25.h),
                const Center(
                    child: Text(
                  'Let’s you in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                )),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ReusableButton(
                    text: 'Sign in with Email',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
             const   buildDivider(
                  text: 'or',
                ),

                buildRowField(
                  title: 'Don’t have an account?',
                  subtitle: 'Sign up',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                ),
               const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                      children: <TextSpan>[
                     const   TextSpan(text: 'By signing up, you agree to our '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: AppColors.primaryBackground),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(PrivacyPolicy());
                            },
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Community Guidelines',
                          style: TextStyle(color: AppColors.primaryBackground),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                            Get.to(CommunityGuidelines());
                              // launchURL('https://your-community-guidelines-url.com');
                            },
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            );
          }
        }),
      ),
    );
  }
}
