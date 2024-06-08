import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../screens/search/search_screen.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl; // Assuming you have a thumbnail URL for each video

  const VideoPlayerItem(
      {Key? key, required this.videoUrl, required this.thumbnailUrl})
      : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController playerController;
  bool _isVideoInitialized = false; // Track if video is initialized
  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
        }
      });
    playerController.setLooping(true);
    playerController.play();

    // Add a listener to the video player controller
    playerController.addListener(() {
      if (mounted) {
        setState(() {
          // This empty setState will trigger a rebuild whenever the video player's state changes
        });
      }
    });
  }

  @override
  void dispose() {
    playerController.removeListener(() {}); // Remove the listener on dispose
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          setState(() {
            if (playerController.value.isPlaying) {
              playerController.pause();
            } else {
              playerController.play();
            }
          });
        },
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!_isVideoInitialized)
                widget.thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.asset("assets/FlickReels.png"),
              if (_isVideoInitialized)
                AspectRatio(
                  aspectRatio: playerController.value.aspectRatio,
                  child: VideoPlayer(playerController),
                ),
              if (_isVideoInitialized && !playerController.value.isPlaying)
                const Icon(Icons.play_arrow_rounded,
                    size: 64, color: Colors.white70),
              if (!_isVideoInitialized)
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight:
                        1.5, // Adjust the height of the progress indicator
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBackground),
                  ),
                ),
            ],
          ),
        ),
      ),
      // Positioned(
      //   top: 10,
      //   right: 16,
      //   child: IconButton(
      //     icon: Icon(Icons.search, color: Colors.white),
      //     onPressed: () {
      //       playerController.pause();
      //       Navigator.pushNamed(context, AppRoutes.search);
      //     },
      //   ),
      // ),
    ]);
  }
}
