import 'package:flick_reels/screens/script_generator/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
class text_with_icon_row extends StatelessWidget {
  const text_with_icon_row({
    super.key,
    required this.text,
    required this.icon,
  });
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reusable_scipt_text(
            text: text,
          ),
          const Spacer(),
          SizedBox(
              height: 20, width: 20, child: Image.asset("assets/$icon.png")),
        ],
      ),
    );
  }
}
