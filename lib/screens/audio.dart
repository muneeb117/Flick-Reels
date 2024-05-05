import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class UploadProcessVideoScreen extends StatefulWidget {
  @override
  _UploadProcessVideoScreenState createState() => _UploadProcessVideoScreenState();
}

class _UploadProcessVideoScreenState extends State<UploadProcessVideoScreen> {
  VideoPlayerController? _videoController;
  bool _isProcessing = false;

  Future<void> _pickAndUploadVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _isProcessing = true);
      File videoFile = File(pickedFile.path);
      await _uploadVideoAndGetAudio(videoFile);
    }
  }

  Future<void> _uploadVideoAndGetAudio(File videoFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.100.41:5000/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', videoFile.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File enhancedAudioFile = File('$tempPath/enhancedAudio.mp3');
      await enhancedAudioFile.writeAsBytes(response.bodyBytes);
      await _mergeAudioAndVideo(enhancedAudioFile.path, videoFile.path);
    } else {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _mergeAudioAndVideo(String audioPath, String videoPath) async {
    final outputFilePath = await _mergeFiles(audioPath, videoPath);
    _videoController = VideoPlayerController.file(File(outputFilePath))
      ..initialize().then((_) {
        setState(() {
          _videoController!.play();
          _isProcessing = false;
        });
      });
  }

  Future<String> _mergeFiles(String audioPath, String videoPath) async {
    final outputDirectory = await getApplicationDocumentsDirectory();
    final outputPath = '${outputDirectory.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final command = '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -strict experimental -map 0:v -map 1:a "$outputPath"';
    await FFmpegKit.execute(command);
    return outputPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload and Process Video')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isProcessing ? null : _pickAndUploadVideo,
                child: Text(_isProcessing ? 'Processing...' : 'Upload Video'),
              ),
              if (_videoController != null && _videoController!.value.isInitialized)
                SizedBox(
                  height: 500,


                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
