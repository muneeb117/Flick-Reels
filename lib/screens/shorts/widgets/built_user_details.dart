import 'package:flick_reels/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/video.dart';
import 'build_profile.dart';


class builtUserDetails extends StatelessWidget {
  const builtUserDetails({
    super.key,
    required this.data,
  });

  final Video data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment
              .start,
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap:(){
                Get.to(ProfileScreen(uid: data.userId));

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center,
                children: [
                  buildProfile(data.userProfileImage),
                  Expanded(

                    child: Text(
                      data.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0),
              child: Text(
                data.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0),
              child: Row(
                children: [

                  Text(
                    data.songName,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      // Handle overflow

                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
