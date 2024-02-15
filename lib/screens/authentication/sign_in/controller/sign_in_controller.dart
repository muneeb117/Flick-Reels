import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../global.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/toast_info.dart';
import '../bloc/sign_in_bloc.dart';
class SignInController {
  final BuildContext context;

  const SignInController({required this.context});

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        final state = context.read<SignInBloc>().state;
        String emailAddress = state.email;
        String password = state.password;
        if (emailAddress.isEmpty || password.isEmpty) {
          toastInfo(msg: "Email and password must be filled in", context: context);
          return;
        }

        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);
        User? user = credential.user;

        if (user == null || !user.emailVerified) {
          toastInfo(msg: "Login failed. Please check your credentials.", context: context);
          return;
        }

        // Check the user status (suspended/banned)
        if (!await _checkUserStatus(user.uid)) {
          // User is suspended/banned, sign them out and redirect to sign-in screen
          await FirebaseAuth.instance.signOut();
          // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
          return; // Stop further execution
        }

        // If user is not suspended/banned, proceed to application
        String? token = await user.getIdToken();
        await Global.storageServices.setString(AppConstants.STORAGE_USER_TOKEN_KEY, token!);
         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.application, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    }

  }
  Future<bool> _checkUserStatus(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      Get.snackbar("User", "User Data Not Found");
      return false;
    }
    var userData = userDoc.data() as Map<String, dynamic>;

    if (userData['isPermanentlyBlocked'] == true) {
      Get.snackbar("Account", "This account has been blocked");
      return false;
    }

    if (userData['isSuspended'] == true) {
      // DateTime? suspensionEnd = userData['suspensionEnd'] != null ? (userData['suspensionEnd'] as Timestamp).toDate() : null;
      //
      // // If suspensionEnd is null or in the future, the account is still suspended
      // if (suspensionEnd == null || suspensionEnd.isAfter(DateTime.now())) {
      //   String suspensionMessage = suspensionEnd != null ? "This account is currently suspended until ${suspensionEnd.toLocal()}" : "This account is currently suspended";
      //   Get.snackbar("Account", suspensionMessage);
      //   return false;
      // }
      Get.snackbar("Account", "This account has been suspended");

      return false;
    }

    return true; // User is not suspended or suspension has expired
  }


  void _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == "user-not-found") {
      toastInfo(msg: "No user found for that email", context: context);
    } else if (e.code == "wrong-password") {
      toastInfo(msg: "Incorrect password provided for that user", context: context);
    } else if (e.code == "invalid-email") {
      toastInfo(msg: "The email address is not in a valid format", context: context);
    } else {
      toastInfo(msg: "An error occurred: ${e.message}", context: context);
    }
  }
}
