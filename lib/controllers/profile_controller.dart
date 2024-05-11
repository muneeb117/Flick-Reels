import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/video.dart';
import '../utils/app_constraints.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _users = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get users => _users.value;
  final Rx<String> _uid = "".obs;
  Rx<List<Video>> userVideos = Rx<List<Video>>([]);

  @override
  void onInit() {
    super.onInit();
    // fetchUserVideos();
  }
  void updateUserId(String uid) {
    _uid.value = uid;
    // Reset user data to an empty state or a placeholder
    _users.value = {
      'name': 'Loading...',
      'profilePhoto': 'assets/user.png',
      'likes': '0',
      'followers': '0',
      'following': '0',
      'isFollowing': false,
    };
    update(); // Force UI to refresh immediately with placeholder data
    getUserData(); // Then load actual data
  }

  getUserData() async {
    if (_uid.value.isEmpty) {
      print('UID is empty, aborting Firestore query.');
      return;
    }
    List<String> thumbnails = [];
    int totalLikes = 0; // Variable to store the total likes count

    // Fetch the user's videos
    var myVideos = await firestore
        .collection('videos')
        .where('userId', isEqualTo: _uid.value)
        .get();

    for (var doc in myVideos.docs) {
      var data = doc.data() as Map<String, dynamic>;
      thumbnails.add(data['thumbnailUrl']);
      List<dynamic> likeList = data['likeList'] ?? [];
      totalLikes += likeList.length;
    }

    DocumentSnapshot userDoc = await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;

    String name = userData['name'];
    String profilePhoto = userData['image'];
    int followers = 0;
    int following = 0;

    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    // Check if the user is already followed by the current user
    DocumentSnapshot isFollowingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user!.uid)
        .get();

    bool isFollowing = isFollowingDoc.exists;

    _users.value = {
      'name': name,
      'profilePhoto': profilePhoto,
      'likes': totalLikes.toString(),
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing, // Ensure this key is always present
    };
    update(); // Call update to refresh the UI with the new data
  }
  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user!.uid)
        .get();

    bool isFollowingNow;
    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user!.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      isFollowingNow = true;
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user!.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      isFollowingNow = false;
    }

    // Update followers count
    _users.value.update(
      'followers',
          (value) => isFollowingNow ? (int.parse(value) + 1).toString() : (int.parse(value) - 1).toString(),
      ifAbsent: () => isFollowingNow ? '1' : '0',
    );

    // Update 'isFollowing' state
    _users.value['isFollowing'] = isFollowingNow;
    update(); // Update the UI
  }
}
