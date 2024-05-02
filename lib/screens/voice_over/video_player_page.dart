import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlayPage extends StatefulWidget {
  final String videoPath;
  final String subtitleText;

  VideoPlayPage({required this.videoPath, required this.subtitleText});

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeAndPlayVideo(widget.videoPath);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
  }

  Future<void> _initializeAndPlayVideo(String videoPath) async {
    _videoPlayerController?.dispose(); // Dispose the old controller
    _videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Over Video Player'),
      ),
      body: Center(
        child: _videoPlayerController == null || !_videoPlayerController!.value.isInitialized
            ? CircularProgressIndicator()
            : Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            ),
            Container(
              color: Colors.black54,
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.subtitleText,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_videoPlayerController!.value.isPlaying) {
              _videoPlayerController!.pause();
            } else {
              _videoPlayerController!.play();
            }
          });
        },
        child: Icon(
          _videoPlayerController != null && _videoPlayerController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}
