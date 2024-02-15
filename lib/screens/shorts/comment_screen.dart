import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as tago;

import '../../Controllers/comment_controller.dart';
import '../../models/comment.dart';
import '../../utils/app_constraints.dart';
import '../../utils/colors.dart'; // Ensure this is correctly imported
class CommentScreen extends StatelessWidget {
  final String id;
  final TextEditingController _commentController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    commentController.updatePostId(id);

    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.6, // Increased initial size
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDragHandle(),
                  Expanded(child: _buildCommentsList(scrollController)),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: _buildCommentInput(context),
        ),
      ],
    );
  }
  Widget _buildCommentsList(ScrollController scrollController) {
    return Obx(() {
      if (commentController.comments.isEmpty) {
        return Center(child: Text("No comments yet")); // or any other placeholder
      }

      return ListView.builder(
        controller: scrollController, // Important for scrolling within DraggableScrollableSheet
        itemCount: commentController.comments.length,
        itemBuilder: (context, index) {
          final comment = commentController.comments[index];
          return _buildCommentItem(comment);
        },
      );
    });
  }


  Widget _buildCommentItem(Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        backgroundImage: NetworkImage(comment.profilePhoto),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' ${comment.userName}',
            style: TextStyle(
              overflow: TextOverflow.ellipsis, // Truncate long usernames

              fontSize: 15,
              color: AppColors.primaryBackground,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            ' ${comment.comment}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            Text(
              '${tago.format(comment.datePublshed.toDate())}',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(width: 5),
            Text('${comment.likes.length} likes',
                style: TextStyle(fontSize: 12, color: Colors.black))
          ],
        ),
      ),
      trailing: InkWell(
        onTap: () => commentController.likeComment(comment.id),
        child: Icon(
          Icons.favorite,
          size: 25,
          color: comment.likes.contains(authController.user!.uid) ? Colors.red : Colors.black,
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      color: Colors.white, // White background for the entire row
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _commentController,
              style: TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => commentController.postComment(_commentController.text),
            child: Text('Send', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

