import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          bool isUserMessage = widget.messages[index]['isUserMessage'];
          return Align(
            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isUserMessage ? AppColors.primaryBackground : Colors.grey[850],
                borderRadius: BorderRadius.circular(18),
              ),
              constraints: BoxConstraints(maxWidth: w * 2 / 3),
              child: Text(widget.messages[index]['message'].text.text[0], style: TextStyle(color: Colors.white)),
            ),
          );
        },
        separatorBuilder: (_, i) => SizedBox(height: 5),
        itemCount: widget.messages.length);
  }
}
