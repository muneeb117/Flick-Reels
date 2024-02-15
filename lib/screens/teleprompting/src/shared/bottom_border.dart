import 'package:flutter/material.dart';

/// A widget that draws a bottom border.
class BottomBorder extends StatelessWidget {
  const BottomBorder({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orangeAccent,
            Colors.pink,

          ],
        ),
      ),
    );
  }
}
