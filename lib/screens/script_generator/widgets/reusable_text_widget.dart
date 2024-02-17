import 'package:flutter/material.dart';
class reusable_scipt_text extends StatelessWidget {
  const reusable_scipt_text({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
