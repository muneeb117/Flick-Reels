import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Comment{
  String userName;
  String comment;
  final datePublshed;
  List likes;
  String profilePhoto;
  String uid;
  String id;
  Comment({
    required this.userName,
    required this.comment,
    required this.datePublshed,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
});
  Map<String, dynamic> toJson()=>{
    'userName':userName,
    'comment':comment,
    'datePublshed':datePublshed,
    'likes':likes,
    'profilePhoto':profilePhoto,
    'uid':uid,
    "id":id,
  };
  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      userName: snapshot['userName'],
      comment: snapshot['comment'],
      datePublshed: snapshot['datePublshed'],
      likes: snapshot['likes'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }
}