import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Controllers/video_controller.dart';
import '../../../models/video.dart';
import '../../../utils/app_constraints.dart';
import '../comment_screen.dart';
import 'download_share_video.dart';

class LikeShareComment extends StatefulWidget {
  final Size size;
  final VideoController videoController;
  final Video data;
  final ShareVideo shareVideo;

  const LikeShareComment({
    super.key,
    required this.size,
    required this.videoController,
    required this.data,
    required this.shareVideo,
  });

  @override
  _LikeShareCommentState createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.data.likeList.contains(authController.user!.uid); // Initialize isLiked based on initial data
    likeCount = widget.data.likeList.length;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }
    });
    widget.videoController.likeVideo(widget.data.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(top: widget.size.height / 5),
      child: Column(
        children: [
          SizedBox(height: 180.h),
          Column(
            children: [
              InkWell(
                onTap: toggleLike,
                child: Icon(
                  Icons.favorite,
                  size: 33,
                  color: isLiked ? Colors.red : Colors.white,
                ),
              ),
              SizedBox(height: 7),
              Text(
                likeCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return CommentScreen(id: widget.data.videoId);
                    },
                  );
                },
                child: SvgPicture.asset(
                  "assets/chat_1.svg",
                  height: 28,
                  width: 28,
                ),
              ),
              SizedBox(height: 7),
              Text(
                widget.data.totalComment.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              InkWell(
                onTap: () => widget.shareVideo.showShareAndReportSheet(context, widget.data.videoId),
                child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/send.png"),
                ),
              ),
              SizedBox(height: 7),
              Text(
                widget.data.totalShare.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
