import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_reels/controllers/uploadVideoController.dart';
// Other imports...

class ConfirmVideoScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmVideoScreen({Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  @override
  State<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  VideoPlayerController? _videoController;
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  // final UploadVideoController uploadVideoController = Get.find<UploadVideoController>();
  final UploadVideoController uploadVideoController = Get.put(
      UploadVideoController());

  double _uploadProgress = 0.0;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
        _videoController!.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _songNameController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Video')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildVideoPlayer(),
            _buildUploadProgressIndicator(),
            _buildVideoInfoForm(),
            _buildUploadButton(),
            // Re
          ],
        ),
      ),
    );
  }

  Widget _buildUploadProgressIndicator() {
    return _isUploading
        ? LinearProgressIndicator(
      value: _uploadProgress,
      backgroundColor: Colors.grey.shade300,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    )
        : SizedBox(); // Return an empty box when not uploading
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: _isUploading ? null : _uploadVideo,
        // Disable button when uploading
        child: _isUploading
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Upload Video'),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return _videoController != null && _videoController!.value.isInitialized
        ? AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    )
        : Container(
      height: 200, // Placeholder height
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildVideoInfoForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _songNameController,
            decoration: InputDecoration(
              labelText: 'Song Name',
              // Other decoration properties...
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _captionController,
            decoration: InputDecoration(
              labelText: 'Title',
              // Other decoration properties...
            ),
          ),
          // SizedBox(height: 20),
          // _isUploading
          //     ? CircularProgressIndicator()
          //     : ElevatedButton(
          //   onPressed: _uploadVideo,
          //   child: Text('Upload Video'),
          // ),
        ],
      ),
    );
  }

  void _uploadVideo() async {
    if (_songNameController.text.isEmpty || _captionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      await uploadVideoController.uploadVideo(
        _songNameController.text,
        _captionController.text,
        widget.videoPath,
        context,
        onProgress: (progress) {
          print("Upload Progress: $progress"); // Debug print
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      Get.snackbar('Success', 'Video uploaded successfully.');
    } catch (e) {
      Get.snackbar('Upload Failed', 'Failed to upload video: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }
}