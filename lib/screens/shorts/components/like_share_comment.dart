import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Controllers/video_controller.dart';
import '../../../models/video.dart';
import '../../../utils/app_constraints.dart';
import '../comment_screen.dart';
import 'download_share_video.dart';
class like_share_comment extends StatelessWidget {
  const like_share_comment({
    super.key,
    required this.size,
    required this.videoController,
    required this.data,
    required this.shareVideo,
  });

  final Size size;
  final VideoController videoController;
  final Video data;
  final ShareVideo shareVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(top: size.height / 5),
      child: Column(
        children: [
          SizedBox(
            height: 180.h,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  videoController.likeVideo(
                      data.videoId);
                },
                child: Icon(
                  Icons.favorite,
                  size: 33,
                  color: data.likeList.contains(
                      authController.user!.uid)
                      ? Colors.red
                      : Colors.white,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                data.likeList.length.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors
                        .transparent,
                    builder: (BuildContext context) {
                      return CommentScreen(
                          id: data.videoId);
                    },
                  );
                },
                child:  SvgPicture.asset(
                  "assets/chat_1.svg",
                  height: 28,
                  width: 28,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                data.totalComment.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              InkWell(
                onTap: () =>
                    shareVideo
                        .showShareAndReportSheet(
                        context, data.videoId),
                child: Container(
                    height: 25,
                    width: 25,
                    child:
                    Image.asset("assets/send.png")),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                data.totalShare.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}