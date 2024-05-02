import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressIndicatorPainter extends CustomPainter {
  final VideoPlayerController videoController;

  VideoProgressIndicatorPainter({required this.videoController});

  @override
  void paint(Canvas canvas, Size size) {
    if (videoController.value.duration.inMilliseconds == 0) {
      return;
    }

    final double progress = videoController.value.position.inMilliseconds /
        videoController.value.duration.inMilliseconds;
    final Paint paint = Paint()
      ..color = Colors.white // Circle color
      ..style = PaintingStyle.fill;

    final double circleRadius = 5.0; // Radius of the circle
    final Offset circleOffset = Offset(
      size.width * progress,
      size.height / 2,
    );

    canvas.drawCircle(circleOffset, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
