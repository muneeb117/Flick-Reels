import 'package:file_picker/file_picker.dart';
import 'package:flick_reels/screens/audio_enhancemnet/audio_enhancement_screen.dart';
import 'package:flutter/material.dart';

class NoisyVideo{
  Future<void> pickAndUploadVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      var filePath = result.files.single.path;
      if (filePath != null && filePath.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AudioEnhancementScreen(videoPath: filePath)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video selected')),
        );
      }
    }
  }
}