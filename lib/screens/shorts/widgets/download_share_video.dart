import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Controllers/video_controller.dart';
import '../report_screen/report_screen.dart';

class ShareVideo extends GetxController {
  Dio dio = Dio();
  void showShareAndReportSheet(BuildContext context, String videoId) {
    final VideoController videoController = Get.find<VideoController>();
    String currentVideoUrl = videoController.getCurrentVideoUrl(videoId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.4,
          builder: (_, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding:const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShareOption(
                        context: context,
                        iconPath: "assets/whatsapp.png",
                        title: 'WhatsApp',
                        videoUrl: currentVideoUrl,
                        fileName: "video.mp4",
                        videoId: videoId,
                      ),
                     const SizedBox(
                        width: 5,
                      ),
                      _buildShareOption(
                        context: context,
                        iconPath: "assets/instagram.png",
                        title: 'Instagram',
                        videoUrl: currentVideoUrl,
                        fileName: "video.mp4",
                        videoId: videoId,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      _buildShareOption(
                        context: context,
                        iconPath: "assets/facebook.png",
                        title: 'Facebook',
                        videoUrl: currentVideoUrl,
                        fileName: "video.mp4",
                        videoId: videoId,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      _buildShareOption(
                        context: context,
                        iconPath: "assets/tiktok.png",
                        title: 'Tiktok',
                        videoUrl: currentVideoUrl,
                        fileName: "video.mp4",
                        videoId: videoId,
                      ),
                    ],
                  ),
                  const   SizedBox(
                    height: 20,
                  ),
                  const  Divider(),
                  ListTile(
                    leading: Icon(Icons.report_problem),
                    title: const Text(
                      'Report a Problem',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () => _showReportScreen(context, videoId),
                  ),
                  ListTile(
                    leading: Icon(Icons.save_alt),
                    title:const Text(
                      'Save Video',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () => downloadAndSaveVideo(
                        context, currentVideoUrl, "video.mp4"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShareOption({
    required BuildContext context,
    required String iconPath,
    required String title,
    required String videoUrl,
    required String fileName,
    required String videoId,
  }) {
    return GestureDetector(
      onTap: () =>
          _downloadAndShareVideo(context, videoUrl, fileName, title, videoId),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, height: 50), // Icon
            Text(title), // Text label
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAndShareVideo(BuildContext context, String videoUrl,
      String fileName, String platform, String videoId) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      // Download the video
      await dio.download(videoUrl, filePath);

      Get.back(); // Dismiss the progress dialog

      // Share the video file
      await Share.shareXFiles([XFile(filePath)],
          text: 'Check out this video from Flick Reels!');

      // Update the share count
      _increaseShareCount(videoId);
    } catch (e) {
      Get.back(); // Ensure the loading dialog is dismissed in case of an error
      Get.snackbar('Error', 'Failed to share video.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> downloadAndSaveVideo(
      BuildContext context, String videoUrl, String fileName) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      var tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$fileName';

      var response = await dio.download(videoUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          // You can show the download progress here
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      });

      if (response.statusCode == 200) {
        final result = await ImageGallerySaver.saveFile(filePath);
        Get.back(); // Close loading dialog
        if (result['isSuccess']) {
          Get.snackbar('Success', 'Video saved to device.',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Failed to save video.',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.back(); // Close loading dialog
        Get.snackbar('Error', 'Download failed.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back(); // Ensure the loading dialog is dismissed in case of an error
      Get.snackbar('Error', 'Failed to download and save video. Error: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _increaseShareCount(String videoId) async {
    final DocumentReference videoRef =
        FirebaseFirestore.instance.collection('videos').doc(videoId);
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot videoSnapshot = await transaction.get(videoRef);
      if (videoSnapshot.exists) {
        int currentShares = videoSnapshot['totalShare'] ?? 0;
        transaction.update(videoRef, {'totalShare': currentShares + 1});
      }
    }).then((result) {
      print("Share count updated successfully.");
    }).catchError((error) {
      print("Failed to update share count: $error");
    });
  }

  void _showReportScreen(BuildContext context, String videoId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReportScreen(videoId: videoId)));

// Additional methods as needed...
  }
}
