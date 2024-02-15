import 'package:flick_reels/screens/splash_screen/bloc/splash_bloc.dart';
import 'package:flick_reels/screens/splash_screen/bloc/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/name.dart';
import 'bloc/splash_states.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:const Duration(seconds: 3),
    )..repeat();

    _controller.addListener(() {
      BlocProvider.of<SplashBloc>(context).add(UpdateRotation(_controller.value * 2 * 3.14159));
    });

    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SplashBloc, SplashScreenState>(
          builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 200.h, left: 60.w, right: 60.w),
              height: 260,
              width: 309,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                    image: AssetImage("assets/FlickReels.png"),
                    fit: BoxFit.cover,
                  )),
              ),
              // child: Center(
              //     child: SvgPicture.asset("assets/FlickReels.svg")),

            // SvgPicture.asset("assets/FlickReels.svg"),
            SizedBox(
              height: 50.h,
            ),
            Transform.rotate(
              angle: state.rotationAngle,
              child: SvgPicture.asset('assets/loading_indicator.svg'),
            ),
          ],
        );
      }),
    );
  }
}
