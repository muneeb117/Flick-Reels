import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flick_reels/screens/discover/bloc/discover_events.dart';
import 'package:flick_reels/screens/discover/bloc/discover_state.dart';
import 'package:flick_reels/screens/discover/widgets/feature_tile_widget.dart';
import 'package:flick_reels/screens/discover/widgets/discover_page_widgets.dart';
import 'package:flick_reels/screens/profile/profile_screen.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/video_upload.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../audio.dart';
import '../audio_enhancemnet/audio_enhancement_screen.dart';
import '../audio_enhancemnet/widgets/upload_noisy_video.dart';
import 'bloc/discvoer_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  User? currentUserDetails;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoScroll();

    fetchUserDetails();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= 3) {
          nextPage = 0; // Go to the first page if it's the last page
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 1200),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      User user = User.fromSnap(userDoc);
      setState(() {
        currentUserDetails = user;
      });
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PickVideo pickVideo = PickVideo();
    final NoisyVideo noisyVideo = NoisyVideo();
    return BlocBuilder<DiscoverBloc, DiscoverStates>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(
              "Flick Reels",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 23,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            if (currentUserDetails != null)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(ProfileScreen(uid: authController.user!.uid));
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(currentUserDetails!.image),
                  ),
                ),
              ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    onPageChanged: (index) {
                      state.page = index;
                      BlocProvider.of<DiscoverBloc>(context)
                          .add(DiscoverEvents());
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return buildContainerPage(
                        image: data[index]['image'],
                      );
                    }),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      data.length, (index) => buildDot(index, state.page))),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FeatureTile(
                      title: 'Audio Enhance',
                      iconPath: 'disover_container_1',
                      subtitle: 'Enhanced Your Audio of Videos With AI.',
                      onTap: () {
                        noisyVideo.pickAndUploadVideo(context);

                      }
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 AudioEnhancementScreen()));
                    //   },
                    // ),
                    ),
                    FeatureTile(
                      title: 'Voice\nOver',
                      iconPath: 'disover_container_2',
                      subtitle: 'Generate natural voiceovers with AI.',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.voiceOver);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FeatureTile(
                      title: 'Generate Subtitle',
                      iconPath: 'disover_container_3',
                      subtitle: 'Create subtitles for your content with AI.',
                      onTap: () {
                        pickVideo.pickAndUploadVideo(context);
                      },
                    ),
                    FeatureTile(
                      title: 'Script & Teleprompt',
                      iconPath: 'disover_container_4',
                      subtitle:
                          'Generate script for your short video & Teleprompt.',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.script);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
