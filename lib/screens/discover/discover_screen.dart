import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flick_reels/screens/discover/bloc/discover_events.dart';
import 'package:flick_reels/screens/discover/bloc/discover_state.dart';
import 'package:flick_reels/screens/discover/widgets/feature_tile_widget.dart';
import 'package:flick_reels/screens/discover/widgets/discover_page_widgets.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import 'bloc/discvoer_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  User? currentUserDetails;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
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
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverStates>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(
              "Flick Reels",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 23,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            if (currentUserDetails != null)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(currentUserDetails!.image),
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
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    onPageChanged: (index) {
                      state.page = index;
                      BlocProvider.of<DiscoverBloc>(context)
                          .add(DiscoverEvents());
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return buildContainer(
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
                      onTap: () {},
                    ),
                    FeatureTile(
                      title: 'Voice\nOver',
                      iconPath: 'disover_container_2',
                      subtitle: 'Generate natural voiceovers with AI.',
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    FeatureTile(
                      title: 'Script & Teleprompt',
                      iconPath: 'disover_container_4',
                      subtitle: 'Generate script for your short video & Teleprompt.',
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
