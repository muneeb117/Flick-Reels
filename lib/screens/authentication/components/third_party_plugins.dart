import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_reels/screens/authentication/components/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../components/loading_indicator.dart';
import '../../../global.dart';
import '../../../models/user.dart' as userModel;
import '../../../routes/name.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/colors.dart';
import 'package:get/get.dart';

GestureDetector buildThirdParyPlugin(
    {required String iconPath, Function()? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 50.h,
      width: 70.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.strokeColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(child: SvgPicture.asset(iconPath)),
    ),
  );
}
class third_party_main extends StatelessWidget {
  third_party_main({
    super.key,
    required this.text,
    required this.imagePath, this.onTap,
  });
  final String imagePath;
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.strokeColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imagePath),
            SizedBox(
              width: 10.w,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}


class GoogleAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void signInWithGoogle(BuildContext context) async {
    final loadingController = Get.find<LoadingController>();
    try {
      loadingController.setLoading(true); // Show loading indicator
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        loadingController.setLoading(false); // Hide loading indicator
        return; // User canceled the login process
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        await storeUserDataInFirestore(user, context);
      }
      loadingController.setLoading(false); // Hide loading indicator
    } catch (error) {
      loadingController.setLoading(false); // Hide loading indicator
      print(error.toString());
    }
  }
}

class FacebookAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void loginWithFacebook(BuildContext context) async {
    final loadingController = Get.find<LoadingController>();
    try {
      loadingController.setLoading(true); // Show loading indicator
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        loadingController.setLoading(false); // Hide loading indicator
        Get.snackbar("Login", "Login with Facebook unsuccessful");
        return;
      }

      final AuthCredential facebookCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      User? user = userCredential.user;
      if (user != null) {
        await storeUserDataInFirestore(user, context);
      }
      loadingController.setLoading(false); // Hide loading indicator
    } catch (error) {
      loadingController.setLoading(false); // Hide loading indicator
      print(error.toString());
    }
  }
}

Future<void> storeUserDataInFirestore(User firebaseUser, BuildContext context) async {
  userModel.User newUser = userModel.User(
    name: firebaseUser.displayName ?? "",
    uid: firebaseUser.uid,
    image: firebaseUser.photoURL ?? "",
    email: firebaseUser.email ?? "",
  );

  try {
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set(newUser.toJson());
    String? token = await firebaseUser.getIdToken();
    if (token != null) {
      await Global.storageServices.setString(AppConstants.STORAGE_USER_TOKEN_KEY, token);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.application, (route) => false);
    }
  } catch (e) {print("Error writing to Firestore: $e");
  }
}