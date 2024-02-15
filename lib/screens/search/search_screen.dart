import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Controllers/search_controller.dart';
import '../../models/user.dart';
import '../../utils/colors.dart';
import '../profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SerchController _searchController = Get.put(SerchController());

  @override
  void initState() {
    super.initState();
    // Delay the resetSearch call to avoid setState() during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.resetSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
      
      
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back)),
                Expanded(
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
      
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                         contentPadding: EdgeInsets.only(top:30.h),
                        prefixIcon: Icon(Icons.search, color: AppColors.primaryBackground,size: 22,),
                      ),
                      onFieldSubmitted: (value) => _searchController.searchUser(value),
                    ),
                  ),
                ),
              ],
            ),
      
      
            Expanded(
              child: Obx(() {
                if (_searchController.searchedUsers.isEmpty && _searchController.hasSearched) {
                  return Center(
                    child: Text(
                      'No User Found',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _searchController.searchedUsers.length,
                    itemBuilder: (context, index) {
                      User user = _searchController.searchedUsers[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: user.uid),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: CachedNetworkImageProvider(user.image),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              color: AppColors.primaryBackground,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
