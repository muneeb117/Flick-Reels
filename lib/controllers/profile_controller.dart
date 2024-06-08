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
    _users.value = {
      'name': 'Loading...',
      'profilePhoto': 'assets/user.png',
      'likes': '0',
      'followers': '0',
      'following': '0',
      'isFollowing': false,
    };
    update();
    getUserData();
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
  void followUser() async {
    bool isCurrentlyFollowing = _users.value['isFollowing'] ?? false;
    int currentFollowers = int.tryParse(_users.value['followers'] ?? '0') ?? 0;

    // Optimistically update the UI
    _users.value['isFollowing'] = !isCurrentlyFollowing;
    _users.value['followers'] = (!isCurrentlyFollowing ? currentFollowers + 1 : currentFollowers - 1).toString();
    update();  // Update the GetX state to reflect changes immediately

    try {
      if (!isCurrentlyFollowing) {
        // Perform the follow operation
        await firestore.collection('users').doc(_uid.value).collection('followers').doc(authController.user!.uid).set({});
        await firestore.collection('users').doc(authController.user!.uid).collection('following').doc(_uid.value).set({});
      } else {
        // Perform the unfollow operation
        await firestore.collection('users').doc(_uid.value).collection('followers').doc(authController.user!.uid).delete();
        await firestore.collection('users').doc(authController.user!.uid).collection('following').doc(_uid.value).delete();
      }
    } catch (e) {
      // If an error occurs, revert the UI changes
      _users.value['isFollowing'] = isCurrentlyFollowing;
      _users.value['followers'] = currentFollowers.toString();
      update();
    }
  }
}
