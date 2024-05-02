import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../models/video.dart';
import '../screens/shorts/short_video_screen.dart';
import '../utils/app_constraints.dart';

class UploadVideoController extends GetxController {
  static UploadVideoController instanceAuth = Get.find();


  _compressVideoFile(String videoPath) async {
    final compressVideoPath = await VideoCompress.compressVideo(
        videoPath, quality: VideoQuality.LowQuality);
    return compressVideoPath!.file;
  }
  Future<String> _uploadCompressVideoFileToStorage(String videoId, String videoPath, Function(double?) onProgress) async {
    final compressedVideoFile = await _compressVideoFile(videoPath);
    Reference ref = FirebaseStorage.instance.ref().child('All Videos').child(videoId);
    UploadTask uploadTask = ref.putFile(compressedVideoFile);

    uploadTask.snapshotEvents.listen((event) {
      onProgress(event.bytesTransferred.toDouble() / event.totalBytes.toDouble());
      if (event.state == TaskState.success) {
        onProgress(null);
      }
    }).onError((error) {
      // Handle the error
      print('Error uploading video: $error');
    });

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrlOfVideo = await snapshot.ref.getDownloadURL();
    return downloadUrlOfVideo;
  }

  Future<String> _uploadThumbnailToStorage(String videoId, String videoPath, Function(double?) onProgress) async {
    final thumbnailFile = await _getThumbnailImage(videoPath);
    Reference ref = FirebaseStorage.instance.ref().child('All Thumbnail').child(videoId);
    UploadTask uploadTask = ref.putFile(thumbnailFile);

    uploadTask.snapshotEvents.listen((event) {
      onProgress(event.bytesTransferred.toDouble() / event.totalBytes.toDouble());
      if (event.state == TaskState.success) {
        onProgress(null);
      }
    }).onError((error) {
      // Handle the error
      print('Error uploading thumbnail: $error');
    });

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrlOfThumbnail = await snapshot.ref.getDownloadURL();
    return downloadUrlOfThumbnail;
  }
  _getThumbnailImage(String videoPath) async {
    final videoThumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return videoThumbnail;
  }

  Future<void> uploadVideo(String songName, String caption, String videoFilePath, BuildContext context, {required Function(dynamic progress) onProgress}) async {
    try {
      // Get user info from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      var allDocs = await FirebaseFirestore.instance.collection('videos').get();
      int len = allDocs.docs.length;

      // Upload video and get its URL
      String videoDownloadUrl = await _uploadCompressVideoFileToStorage("Video $len", videoFilePath, (progress) {
        onProgress(progress); // Update progress for video upload
      });

      // Upload thumbnail and get its URL
      String thumbnailDownloadUrl = await _uploadThumbnailToStorage("Video $len", videoFilePath, (progress) {
        onProgress(progress); // Update progress for thumbnail upload
      });

      // Create video object
      Video video = Video(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userName: (snapshot.data() as Map<String, dynamic>)['name'],
        userProfileImage: (snapshot.data() as Map<String, dynamic>)['image'],
        videoId: "Video $len",
        totalComment: 0,
        totalShare: 0,
        likeList: [],
        songName: songName,
        caption: caption,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );

      // Save video data to Firestore
      await FirebaseFirestore.instance.collection("videos").doc("Video $len").set(video.toJson());
      // Get.snackbar('New Video', 'You Have Successfully Uploaded a New Video');
     Navigator.pushReplacementNamed(context, AppRoutes.application);
      } catch (e) {
      Get.snackbar('Error', 'Failed to upload video: ${e.toString()}');
    }
  }
}