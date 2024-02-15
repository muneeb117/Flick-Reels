import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/video.dart';
import '../models/user.dart';
import '../utils/app_constraints.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  Map<String, User> _usersMap = {};

  List<Video> get videoList => _videoList.value;


  @override
  void onInit() {
    super.onInit();
    _fetchUsers().then((_) => _videoList.bindStream(_videoStream()));
  }

  Future<void> _fetchUsers() async {
    var userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in userSnapshot.docs) {
      _usersMap[doc.id] = User.fromSnap(doc);
    }
  }
  String getCurrentVideoUrl(String videoId) {
    // Find the video by ID
    final Video? video = videoList.firstWhereOrNull((v) => v.videoId == videoId);
    // Return the video URL if found, else return an empty string or a placeholder URL
    return video?.videoUrl ?? '';
  }
  Stream<List<Video>> _videoStream() {
    return FirebaseFirestore.instance.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        Video video = Video.fromSnap(element);
        User? uploader = _usersMap[video.userId];
        if (!_isVideoHiddenOrUploaderSuspended(video, uploader)) {
          retVal.add(video);
        }
      }
      return retVal;
    });
  }

  bool _isVideoHiddenOrUploaderSuspended(Video video, User? uploader) {
    if (video.isHidden) return true;
    if (uploader == null) return false; // If user data is not found, assume not suspended.

    bool isSuspended = uploader.isSuspended;
    DateTime? suspensionEnd = uploader.suspensionEnd;

    return isSuspended && suspensionEnd != null && suspensionEnd.isAfter(DateTime.now());
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('videos').doc(id).get();
    var uid = authController.user!.uid;
    if ((doc.data()! as dynamic)['likeList'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likeList': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likeList': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
