import 'dart:io';

import 'package:flick_reels/screens/Video_Editor/videoEditor_screen.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart' show OpacityTransition;
import 'package:image_picker/image_picker.dart';

import 'package:video_editor/video_editor.dart';

class VideoPickerScreen extends StatefulWidget {
  static String routeName = "/pick";
  const VideoPickerScreen({super.key});

  @override
  State<VideoPickerScreen> createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  final ImagePicker _picker = ImagePicker();

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Image.asset("assets/photos.png",fit: BoxFit.cover,height: 30,width: 30,),
                title: Text("Select from Gallery",style: TextStyle(color: AppColors.primaryBackground),),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Image.asset("assets/camera.png",fit: BoxFit.cover,height: 30,width: 30,),
                title: Text("Take Video",style: TextStyle(color: AppColors.primaryBackground)),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickMedia(ImageSource source) async {
    final XFile? file;
    if (source == ImageSource.gallery) {
      file = await _picker.pickVideo(source: source);
    } else {
      file = await _picker.pickVideo(source: source);
    }

    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoEditor(file: File(file!.path)),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Video Picker",style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: _showUploadOptions,
          child: Column(
            children: [
            const SizedBox(height: 250,),
              Container(
                  height: 150,
                  width: 270,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 2,
                        color: AppColors.primaryBackground.withOpacity(0.1)
                      )
                    ]

                  ),
                  child: Column(
                    children: [
                      Spacer(),
                      Image.asset(
                        'assets/upload_video.png',
                        height: 80,
                        width: 80,
                      ),
                      Spacer(),
                      const Text("Upload Your Videos",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.primaryBackground)),
                      Spacer(),
                    ],
                  )),
            ],
          ),
        ),
      ),


    );
  }
}
