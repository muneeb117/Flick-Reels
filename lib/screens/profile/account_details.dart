import 'package:flick_reels/screens/rules_privacy/community_guidlines.dart';
import 'package:flick_reels/screens/rules_privacy/privacy_policy.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_profile.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      appBar: AppBar(
        backgroundColor:AppColors.primarySecondaryBackground,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body:  Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Padding(
              padding:  EdgeInsets.only(left: 15.0),
              child: Text(
                "Setting and Privacy",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
           const  SizedBox(height: 15,),
            const Text("Account"),
            const SizedBox(height: 10,),

            Container(
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  account_details_containter(title: 'Account',leadingIcon: Icons.person,onTap: (){
                    Get.to(const EditAccountScreen());
                  },),
                  account_details_containter(title: 'Privacy',leadingIcon: Icons.lock_outline_rounded,onTap: (){
                    Get.to( const PrivacyPolicy());
                  }),
                  account_details_containter(title: 'Community Guidelines',leadingIcon: Icons.security_rounded,onTap: (){
                    Get.to(const CommunityGuidelines());
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            Container(
              decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  account_details_containter(title: 'Report a Problem',leadingIcon: Icons.flag,onTap: (){
                  }),
                  account_details_containter(title: 'Support',leadingIcon: Icons.support,onTap: (){}),
                  account_details_containter(title: 'Terms and Policies',leadingIcon: Icons.error,onTap: (){
                    Get.to(const CommunityGuidelines());
                  }),
                ],
              ),
            ),
            const  SizedBox(height: 20,),

            Container(
              decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  account_details_containter(title: 'Logout',leadingIcon:Icons.logout,onTap: (){
                    authController.signOut();
            }),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class account_details_containter extends StatelessWidget {
   account_details_containter({
    super.key, this.leadingIcon, required this.title, this.onTap,
  });
  final IconData? leadingIcon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const  SizedBox(width: 8,),
            Icon(leadingIcon,color:Colors.grey,size: 18,),
            const   SizedBox(width: 15,),
            Text(
              title,style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black.withOpacity(0.8),
            ),
            ),
            const    Spacer(),
            Icon(
              Icons.arrow_forward_ios,color:Colors.grey.withOpacity(0.6),
              size: 16,
            ),
            const   SizedBox(width: 15,),

          ],
        ),
      ),
    );
  }
}
