import 'package:flick_reels/screens/Video_Editor/videoPicker_page.dart';
import 'package:flick_reels/screens/discover/discover_screen.dart';
import 'package:flick_reels/screens/profile/profile_screen.dart';
import 'package:flick_reels/screens/search/search_screen.dart';
import 'package:flick_reels/screens/upload_video/uploadVideoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/app_constraints.dart';
import '../../../utils/colors.dart';
import '../../advance_media_production_suite/amps_screen.dart';
import '../../shorts/short_video_screen.dart';

Widget buildPage(index) {
  List<Widget> _widgets = [
    ShortVideoScreen(),
    DiscoverScreen(),
    VideoPickerScreen(),
    AdvancedMediaProductionSuite(),
    ProfileScreen(uid: authController.user!.uid,),
  ];
  return _widgets[index];
}

var bottomTabs = [
  BottomNavigationBarItem(
      label: "Shorts",
      icon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset("assets/Video.svg"),
      ),
      activeIcon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset(
          "assets/video-color.svg",
        ),
      )),
  BottomNavigationBarItem(

      label: "Discover",
      icon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset("assets/Discovery.svg"),
      ),
      activeIcon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset(
          "assets/Discovery_color.svg",
        ),
      )),
  BottomNavigationBarItem(
      label: "",
      icon: SizedBox(
        height: 45.h,
        width: 45.w,
        child: SvgPicture.asset("assets/upload_plus.svg"),
      ),
      activeIcon: SizedBox(
        height: 45.h,
        width: 45.w,
        child: SvgPicture.asset("assets/upload_plus.svg"),
      )),

  BottomNavigationBarItem(
      label: "Chat Bot",
      icon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset("assets/chat.svg"),
      ),
      activeIcon: SizedBox(
        height: 22.h,
        width: 22.w,
        child: SvgPicture.asset(
          "assets/Chat-color.svg",
        ),
      )),
  BottomNavigationBarItem(
      label: "Profile",
      icon: SizedBox(
        height: 19.h,
        width: 19.w,
        child: SvgPicture.asset("assets/Profile.svg"),
      ),
      activeIcon: SizedBox(
        height: 19.h,
        width: 19.w,
        child: SvgPicture.asset("assets/profile-color.svg"),
      )),
];
