import 'package:flick_reels/screens/profile/account_details.dart';
import 'package:flick_reels/screens/profile/profile_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Controllers/profile_controller.dart';
import '../../utils/app_constraints.dart';
import '../../utils/colors.dart';


class ProfileScreen extends StatefulWidget {
  static String routeName = "/profileScreen";

  final String uid;
  const ProfileScreen({super.key, required this.uid,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.put(ProfileController());
    profileController.updateUserId(widget.uid);

  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.transparent,
                color: AppColors.primaryBackground,
              ),
            );
          }
          return SafeArea(
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight), // Standard AppBar height
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0,right: 20), // Add your desired padding here
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,

                      actions: [
                        GestureDetector(
                          onTap: (){
                            Get.to(const AccountDetails());
                          },
                          child:const Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                          ),
                        )
                      ],
                      title: Text(
                        controller.users['name'],
                        style:const  TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                ),
                body: SafeArea(
                    child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: controller.users['profilePhoto'],
                              height: 100,
                              width: 100,
                              placeholder: (context, url) => const CircleAvatar(
                                backgroundImage: AssetImage('assets/user.png'), // Asset placeholder
                                radius: 50,
                              ),
                              errorWidget: (context, url, error) => const CircleAvatar(
                                backgroundImage: AssetImage('assets/user.png'), // Asset for error
                                radius: 50,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const  SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildContainer(
                            number: controller.users['likes'],
                            text: 'Likes',
                          ),
                          buildContainer(
                            number: controller.users['followers'],
                            text: 'Followers',
                          ),
                          buildContainer(
                            number: controller.users['following'],
                            text: 'Following',
                          ),
                        ],
                      ),
                  const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        onTap: () {
                          if (widget.uid == authController.user!.uid) {
                            authController.signOut();
                          } else {
                            controller.followUser();
                          }
                        },
                        child: Container(
                          width: 240,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: AppColors.primarySecondaryBackground,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(

                              widget.uid == authController.user?.uid
                                  ? 'Sign Out'
                                  : controller.users['isFollowing']??false
                                      ? 'Unfollow'
                                      : 'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.sp),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      // Expanded(
                      //   child: Obx(() {
                      //     var videos = profileController.userVideos.value;
                      //     print(
                      //         "Displaying Videos: ${videos.length}"); // Debug print
                      //     return GridView.builder(
                      //       itemCount: videos.length,
                      //       gridDelegate:
                      //           SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3,
                      //         crossAxisSpacing: 4,
                      //         mainAxisSpacing: 4,
                      //       ),
                      //       itemBuilder: (context, index) {
                      //         var video = videos[index];
                      //         return GestureDetector(
                      //           onTap: () {
                      //             // Navigate to the video playback screen
                      //             Navigator.of(context).push(
                      //               MaterialPageRoute(
                      //                 builder: (context) => VideoPlaybackScreen(
                      //                     videoUrl: video.videoUrl),
                      //               ),
                      //             );
                      //           },
                      //           child: CachedNetworkImage(
                      //             imageUrl: video.thumbnailUrl,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   }),
                      // ),
                    ],
                  ),
                ))),
          );
        });
  }
}

class buildContainer extends StatelessWidget {
  final String number;
  final String text;
  const buildContainer({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
