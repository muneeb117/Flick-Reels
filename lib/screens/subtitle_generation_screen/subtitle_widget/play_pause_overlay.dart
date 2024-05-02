import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoControlBar extends StatelessWidget {
  final VideoPlayerController controller;
  final String currentSubtitle;
  final Function() onPlayPause;
  final bool isPlaying;
  final Color bgColor;
  final Color fgColor;
  final TextStyle textStyle;

  const VideoControlBar({
    Key? key,
    required this.controller,
    required this.currentSubtitle,
    required this.onPlayPause,
    required this.isPlaying,
    required this.bgColor,
    required this.fgColor,
    required this.textStyle,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (controller.value.isInitialized)
            Container(
              padding: const EdgeInsets.all(5.0),
              color: bgColor,
              child: Text(
                currentSubtitle,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),


          VideoProgressBar(controller: controller, seekTo: (Duration position) => controller.seekTo(position)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                iconSize: 30.0,
                onPressed: onPlayPause,
              ),
              // Add more control buttons as needed
            ],
          ),
        ],
      ),
    );
  }
}

class VideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final Function(Duration) seekTo;

  const VideoProgressBar({
    Key? key,
    required this.controller,
    required this.seekTo,
  }) : super(key: key);

  @override
  _VideoProgressBarState createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  VideoPlayerController get controller => widget.controller;

  void listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoProgressIndicator(
      controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor: Color(0xff706bba),
        bufferedColor: Colors.white.withOpacity(0.3),
        backgroundColor: Colors.white.withOpacity(0.3),
      ),
    );
  }
}
