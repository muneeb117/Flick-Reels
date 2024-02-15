import 'package:flutter/material.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center,
              children: [
                buildProfile(data.userProfileImage),
                Expanded(
                  // Use Expanded
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
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0),
              child: Text(
                data.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
                  const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 15,
                  ),
                  Text(
                    data.songName,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      // Handle overflow

                      color: Colors.white,
                      fontSize: 18,
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
