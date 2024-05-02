//
// import 'package:flick_reels/screens/subtitle_generation_screen/preview_selected_video.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
//
//
// class VideoUploadScreen extends StatefulWidget {
//   @override
//   _VideoUploadScreenState createState() => _VideoUploadScreenState();
// }
//
// class _VideoUploadScreenState extends State<VideoUploadScreen> {
//   Future<void> pickAndUploadVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );
//
//     if (result != null) {
//       var filePath = result.files.single.path;
//       if (filePath != null && filePath.isNotEmpty) {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (context) => VideoPreviewScreen(videoPath: filePath)));
//       } else {
//         // Handle the error or cancellation
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No video selected')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Video'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: (){},
//           // onPressed: _pickAndUploadVideo,
//           child: Text('Pick and Upload Video'),
//         ),
//       ),
//     );
//   }
// }
import 'package:file_picker/file_picker.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/preview_selected_video.dart';
import 'package:flutter/material.dart';

class PickVideo{
  Future<void> pickAndUploadVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      var filePath = result.files.single.path;
      if (filePath != null && filePath.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => VideoPreviewScreen(videoPath: filePath)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video selected')),
        );
      }
    }
  }
}