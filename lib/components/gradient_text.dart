import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  GradientText({
    super.key,
    required this.colors,
    required this.text,
    required this.fontSize,
    this.fontWeight,
  });
  final List<Color> colors;
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // This color must be white to allow the ShaderMask to show the gradient.
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
