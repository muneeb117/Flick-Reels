import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/colors.dart';

class ProfilePlayerItem extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const ProfilePlayerItem({Key? key, required this.videoUrl, required this.thumbnailUrl}) : super(key: key);

  @override
  _ProfilePlayerItemState createState() => _ProfilePlayerItemState();
}

class _ProfilePlayerItemState extends State<ProfilePlayerItem> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  void initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play(); // Auto-play upon initialization
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller == null) {
          initializeVideo(); // Initialize and play the video when tapped
        } else {
          // Toggle play/pause state
          if (_controller!.value.isPlaying) {
            setState(() {
              _controller!.pause();
              _isPlaying = false;

            });
          } else {
            setState(() {

              _controller!.play();
            _isPlaying = true;
            });
          }
        }
        setState(() {}); // Update the UI based on play/pause state
      },
      child: Container(
        alignment: Alignment.center,
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : Stack(
          alignment: Alignment.center,
          children: [
            widget.thumbnailUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: widget.thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
                : Image.asset("assets/FlickReels.png"),

            Icon(
              _isPlaying ?

              Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 45,
              color: Colors.white70,
            ),
              if(_controller == null)
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
    );
  }
}
