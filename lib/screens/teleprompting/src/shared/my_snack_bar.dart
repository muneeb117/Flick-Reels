import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MySnackBar {
  /// Show a snackbar with the given [text] and optional [icon].
  static void show({
    required BuildContext context,
    required String text,
    IconData? icon = Icons.info_outline, // Default to info icon if none provided
    TextStyle? style,
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = const Color(0xFF323232), // A neutral dark background color
  }) {
    showTopSnackBar(
      Overlay.of(context),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.cyanAccent, // A vibrant color for the icon
              size: 24,
            ),
            SizedBox(width: 16), // Spacing between the icon and text
            Expanded(
              child: Text(
                text,
                style: style ?? Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
      displayDuration: duration,
    );
  }

  /// Show an error snackbar with the given [text].
  static void showError({
    required BuildContext context,
    required String text,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      text: text,
      icon: Icons.error_outline, // Explicitly specifying the error icon
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
      duration: duration,
      backgroundColor: Colors.deepOrangeAccent, // A strong color for errors
    );
  }
}
