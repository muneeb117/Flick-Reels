// ... Your existing imports ...
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlaybackScreen extends StatefulWidget {
  final String videoUrl;
  // Add other parameters if needed

  const VideoPlaybackScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Playback')),
      body: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      // Add other UI elements for like, comment, etc. here
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
