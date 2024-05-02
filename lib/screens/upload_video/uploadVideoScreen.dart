// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'confirm_video_screen.dart';
//
// class UploadVideoScreen extends StatefulWidget {
//   static String routeName="/uploadVideo";
//
//   const UploadVideoScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UploadVideoScreen> createState() => _UploadVideoScreenState();
// }
//
// class _UploadVideoScreenState extends State<UploadVideoScreen> {
//   getVideoFile(ImageSource imgSrc)async{
//     final videoFile = await ImagePicker().pickVideo(source: imgSrc);
//     if(videoFile!=null){
//       Get.to(ConfirmVideoScreen(
//         videoFile: File(videoFile.path),
//         videoPath: videoFile.path,
//       ));
//     }
//   }
//
//
//   displayDialogBox(){
//     return showDialog(context: context, builder: (context)=>
//         SimpleDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           children: [
//             SimpleDialogOption(
//               onPressed: (){
//                 getVideoFile(ImageSource.gallery);
//               },
//               child:const Row(
//                 children: [
//                   Icon(Icons.image),
//
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Pick Video From Gallery',style: TextStyle(fontSize: 14),),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//             SimpleDialogOption(
//               onPressed: (){
//                 getVideoFile(ImageSource.camera);
//               },
//               child:const Row(
//                 children: [
//                   Icon(Icons.camera),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Capture Video',style: TextStyle(fontSize: 14),),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//             SimpleDialogOption(
//               onPressed: (){
//                 Get.back();
//               },
//               child:const Row(
//                 children: [
//                   Icon(Icons.cancel),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Cancel',style: TextStyle(fontSize: 14),),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Image.asset(
//                         'assets/icons/upload.png',
//                         height: 40,
//                         width: 40,
//                       ))),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.white,foregroundColor: Colors.pink),
//                   onPressed: () {
//                     displayDialogBox();
//                   },
//                   child: const Text('Upload Your Videos'))
//             ],
//           )),
//     );
//   }
// }
