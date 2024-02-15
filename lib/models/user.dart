import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String uid;
  String image;
  String email;
  bool isSuspended;
  DateTime? suspensionEnd;
  bool isPermanentlyBlocked;

  User({
    required this.name,
    required this.uid,
    required this.image,
    required this.email,
    this.isSuspended = false,
    this.suspensionEnd,
    this.isPermanentlyBlocked = false,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "uid": uid,
    "image": image,
    "email": email,
    "isSuspended": isSuspended,
    "suspensionEnd": suspensionEnd?.millisecondsSinceEpoch,
    "isPermanentlyBlocked": isPermanentlyBlocked,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['name'],
      uid: snapshot['uid'],
      image: snapshot['image'],
      email: snapshot['email'],
      isSuspended: snapshot['isSuspended'] ?? false,
      suspensionEnd: snapshot['suspensionEnd'] != null ? DateTime.fromMillisecondsSinceEpoch(snapshot['suspensionEnd']) : null,
      isPermanentlyBlocked: snapshot['isPermanentlyBlocked'] ?? false,
    );
  }
}
