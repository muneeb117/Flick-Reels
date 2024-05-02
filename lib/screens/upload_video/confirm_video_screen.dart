import 'dart:io';
import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/components/reusable_script_container.dart';
import 'package:flick_reels/utils/toast_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_reels/controllers/uploadVideoController.dart';

import '../../components/confirm_upload_button.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Confirm Video',style: TextStyle(
             fontWeight: FontWeight.w600

          ), ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: _buildVideoPlayer())),
              _buildUploadProgressIndicator(),
              SizedBox(height: 10.h,),
              _buildVideoInfoForm(),
              _buildUploadButton(),
              ],// Re
          ),
        ),
      ),
    );
  }

  Widget _buildUploadProgressIndicator() {
    return _isUploading
        ? Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uploading... ${(_uploadProgress * 100).toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _uploadProgress,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    )
        : SizedBox();
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      child: ConfirmUploadButton(
        text: _isUploading ? 'Uploading...' : 'Confirm Upload',
        onPressed: _isUploading ? null : _uploadVideo,
        isEnabled: !_isUploading,
        gradientColors: _isUploading
            ? [Colors.grey, Colors.grey[400]!]
            : [Colors.pinkAccent, Colors.purpleAccent],
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
      height: 100, // Placeholder height
      child:const  Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildVideoInfoForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          ReusableScriptContainer(hintText: 'Title', child: null, controller: _captionController, maxLines: 1),
         const  SizedBox(height: 10),
          ReusableScriptContainer(hintText: 'Hashtags', child: null, controller: _songNameController, maxLines: 1),


        ],
      ),
    );
  }

  void _uploadVideo() async {
    // Initialize an error message string that can be updated based on the validation.
    String errorMessage = '';

    // Check if the song name is empty.
    if (_songNameController.text.isEmpty) {
      errorMessage += 'Song Name is required. ';
    }

    // Check if the caption (title) is empty.
    if (_captionController.text.isEmpty) {
      errorMessage += 'Title is required.';
    }

    // If there's an error message, display it and return to prevent further execution.
    if (errorMessage.isNotEmpty) {
      toastInfo(context: context, msg: errorMessage);
      // Get.snackbar('Error', errorMessage);
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