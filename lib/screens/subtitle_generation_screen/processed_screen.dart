import 'dart:convert';
import 'dart:io';
import 'package:flick_reels/screens/Video_Editor/videoEditor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/subtitle_model.dart';
const String processSubtitlesUrl = 'http://172.20.4.226:5000/process-subtitles';

class ProcessedScreen extends StatefulWidget {
  final String videoPath;
  final List<Subtitle> subtitles;
  final Color bgColor;
  final Color fgColor;
  final String font;


  const ProcessedScreen({
    Key? key,
    required this.videoPath,
    required this.subtitles, required this.bgColor, required this.fgColor, required this.font,
  }) : super(key: key);

  @override
  _ProcessedScreenState createState() => _ProcessedScreenState();
}

class _ProcessedScreenState extends State<ProcessedScreen> {
  VideoPlayerController? _videoController;
  bool _isLoading = true;
  String? _error;
   String? videoUrl;
  @override
  void initState() {
    super.initState();
    // _videoController!.play();
    _processSubtitlesAndLoadVideo();
  }
  Future<void> _processSubtitlesAndLoadVideo() async {
    try {
      final response = await http.post(
        Uri.parse(processSubtitlesUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'filename': widget.videoPath.split('/').last,
          'edited_subtitles': widget.subtitles.map((subtitle) => subtitle.toJson()).toList(),
          'bg_color': '#' + widget.bgColor.value.toRadixString(16).padLeft(8, '0').substring(2),
          'fg_color': '#' + widget.fgColor.value.toRadixString(16).padLeft(8, '0').substring(2),
          'font': widget.font,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final videoUrl = responseBody['video_url'];

        // Download the video file
        final File videoFile = await _downloadVideoFile(videoUrl);
        // Navigate to the Video Editor screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoEditor(file: videoFile)),
        );

      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to process video: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to process video: $e';
      });
    }
  }

  Future<File> _downloadVideoFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/downloaded_video.mp4');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: _isLoading
          ? Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text('Processing Video....',style: TextStyle(color: Colors.white54),),
                SizedBox(height: 20.h,),
                CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.white,
                ),
              ],
            ),
          )
          : _error != null
          ? Center(child: Text(_error!))
          : _videoController!.value.isInitialized
          ? Center()
          : Center(child: Text('Error initializing video player')),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
