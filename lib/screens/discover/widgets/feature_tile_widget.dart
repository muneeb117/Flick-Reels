import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
class FeatureTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final String subtitle;
  final Function()? onTap;
  const FeatureTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(

        height: 160,
        width: 170,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.strokeColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 15,right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: Text(
                      title,
                      softWrap: true,
                      style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const  Spacer(),
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        "assets/$iconPath.png",
                        fit: BoxFit.cover,
                      )),
                ],
              ),
              const   SizedBox(
                height: 30,
              ),
              Text(
                subtitle,
                style:const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
