import 'package:flick_reels/screens/shorts/widgets/built_user_details.dart';
import 'package:flick_reels/screens/shorts/widgets/download_share_video.dart';
import 'package:flick_reels/screens/shorts/widgets/like_share_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/video_controller.dart';
import '../../components/video_player_item.dart';

class ShortVideoScreen extends StatefulWidget {
  const ShortVideoScreen({Key? key}) : super(key: key);

  @override
  State<ShortVideoScreen> createState() => _ShortVideoScreenState();
}

class _ShortVideoScreenState extends State<ShortVideoScreen> {
  final VideoController videoController = Get.put(VideoController());
  ShareVideo shareVideo = ShareVideo();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(

        body: Obx(() {
          return PageView.builder(
              itemCount: videoController.videoList.length,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final data = videoController.videoList[index];
                return Stack(
                  children: [
                    VideoPlayerItem(
                      videoUrl: data.videoUrl, thumbnailUrl: data.thumbnailUrl,
                    ),
                    if (data.isPromotional)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding:const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border:Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(25),

                          ),
                          child:const Text(
                            'Promotional Content',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 12),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                         SizedBox(
                          height: 80.h,
                        ),
                        Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                builtUserDetails(data: data),
                                LikeShareComment(size: size, videoController: videoController, data: data, shareVideo: shareVideo),

                              ],
                            ))
                      ],
                    )
                  ],
                );
              });
        }),
      ),
    );
  }
}
