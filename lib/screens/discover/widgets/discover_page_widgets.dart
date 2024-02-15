import 'package:flutter/cupertino.dart';

import '../../../utils/colors.dart';

List<Map<String, String>> data = [
  {"image": "discover_1"},
  {"image": "discover_2"},
  {"image": "discover_3"}
];


class buildContainer extends StatelessWidget {
  const buildContainer({
    super.key, required this.image,
  });
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Image.asset("assets/${image}.png"),
    );
  }
}


AnimatedContainer buildDot(int index, int currentPage) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin:const EdgeInsets.only(right: 5),
    height: 6,
    width: currentPage == index ? 16 : 6,
    decoration: BoxDecoration(
      color: currentPage == index ? AppColors.primaryBackground :AppColors.strokeColor,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}