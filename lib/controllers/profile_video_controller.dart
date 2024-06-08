import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video.dart';  // Ensure the path to your Video model is correct

class ProfileVideoController extends GetxController {
  final Rx<List<Video>> _userVideoList = Rx<List<Video>>([]);
  List<Video> get userVideoList => _userVideoList.value;

  // Fetch user-specific videos
  void fetchUserVideos(String userId) {
    _userVideoList.bindStream(
        FirebaseFirestore.instance
            .collection('videos')
            .where('userId', isEqualTo: userId)
            .snapshots()
            .map((QuerySnapshot query) {
          return query.docs.map((doc) => Video.fromSnap(doc)).toList();
        })
    );
  }

  // Delete a specific video by ID
  void deleteVideo(String videoId) async {
    try {
      await FirebaseFirestore.instance.collection('videos').doc(videoId).delete();
      // Remove the video from the list
      _userVideoList.value = _userVideoList.value.where((video) => video.videoId != videoId).toList();
      update();  // Notify listeners of the update
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete video: ${e.toString()}');
    }
  }
}
