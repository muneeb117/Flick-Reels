import 'package:flick_reels/screens/welcome/bloc/welcome_bloc.dart';
import 'package:flick_reels/screens/welcome/bloc/welcome_event.dart';
import 'package:flick_reels/screens/welcome/bloc/welcome_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/build_dot.dart';
import '../../components/reusable_button.dart';
import '../../global.dart';
import '../../routes/name.dart';
import '../../utils/app_constant.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  state.page = index;
                  BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                },
                children: [
                  onBoardingScreen(
                    1,
                    'Next',
                    'Elevate Your Content Creation Experience',
                    'assets/welcome_1.svg',
                    context,
                  ),
                  onBoardingScreen(
                  2,
                    'Next',
                    'Elevate videos with enhanced audio',
                   'assets/welcome_2.svg',
                     context,
                  ),
                  onBoardingScreen(
                    3,
                    'Get Started',
                    'Harness AI Magic for Subtitle Generation',
                     'assets/welcome_3.svg',
                   context,
                  ),
                ],
              ),
              Positioned(
                  bottom: 150.h,
                  child: Row(
                      children: List.generate(
                          3, (index) => buildDot(index, state.page)))),

            ],
          );
        },
      ),
    );
  }

  Widget onBoardingScreen(int index,  String buttonName, String title, String imagePath ,BuildContext context,) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 153.h, left: 62.h, right: 62.h),
          height: 300,
          width: 300,
          child: SvgPicture.asset(imagePath),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          child: Text(title,
              textAlign: TextAlign.center,
              // style: GoogleFonts.urbanist(
              //   fontSize: 25.sp,
              //   fontWeight: FontWeight.bold,
              // )
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          // child: ReusableButton(
          //   onPressed: () {
          //     if (index < 3) {
          //       pageController.animateToPage(index,
          //           duration: const Duration(milliseconds: 500),
          //           curve: Curves.decelerate);
          //     } else {
          //       Global.storageServices.setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
          //       Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signInOption, (route) => false);
          //     }
          //   },
          //   text: buttonName,
          // ),
        ),
      ],
    );
  }
}
