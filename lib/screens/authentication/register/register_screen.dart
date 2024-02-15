import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/screens/authentication/register/bloc/register_bloc.dart';
import 'package:flick_reels/screens/authentication/register/bloc/register_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../routes/name.dart';
import '../../../utils/colors.dart';
import '../../rules_privacy/community_guidlines.dart';
import '../../rules_privacy/privacy_policy.dart';
import '../widgets/ProfileAvatar.dart';
import '../widgets/build_text_field.dart';
import '../widgets/divider.dart';
import '../widgets/reusable_text.dart';
import '../widgets/row_field.dart';
import '../widgets/third_party_plugins.dart';
import 'bloc/register_event.dart';
import 'controller/register_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc,RegisterState>(builder: (context,state){
      return    Scaffold(
        body: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  auth_reusable_text('Sign Up'),
                  SizedBox(
                    height: 30.h,
                  ),
                  ProfileAvatar(),
                  const SizedBox(
                    height: 20,
                  ),
                  BuildTextField(
                      text: 'Name',
                      textType: TextInputType.name,
                      iconName: 'Profile',
                      onValueChange: (value) {
                        context.read<RegisterBloc>().add(
                            NameEvent(value)); // Dispatch email event
                      }
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BuildTextField(
                      text: 'Email',
                      textType: TextInputType.emailAddress,
                      iconName: 'inbox',
                      onValueChange: (value) {
                        context.read<RegisterBloc>().add(
                            EmailEvent(value)); // Dispatch email event
                      }

                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  BuildTextField(
                      text: 'Password',
                      textType: TextInputType.text,
                      iconName: 'lock',
                      onValueChange: (value) {
                        context.read<RegisterBloc>().add(
                            PasswordEvent(value)); // Dispatch email event
                      }
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BuildTextField(
                      text: 'Confirm Password',
                      textType: TextInputType.text,
                      iconName: 'lock',
                      onValueChange: (value) {
                        context.read<RegisterBloc>().add(
                            RePasswordEvent(value)); // Dispatch email event
                      }
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ReusableButton(text: 'Continue',onPressed: (){
                    RegisterController(context:context).handleSignUp();


                  },),
                  const SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: 'By signing up, you agree to our '),
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

                  const SizedBox(height: 40,),
                  const buildDivider(text: 'or',),
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
                  buildRowField(title: "Already have an account?", subtitle: "Log in",onTap: (){
                    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
                  },),
                  const SizedBox(height: 20,),

                ]),
          ),
        ),
      );
    },

    );
  }}