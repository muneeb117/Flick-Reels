import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_reels/screens/profile/account_details.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/authentication_controller.dart';
import '../../models/user.dart' as UserModel;

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  UserModel.User? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      currentUser = UserModel.User.fromSnap(userDoc);
      nameController.text = currentUser?.name ?? '';
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Add this method to update the user's name in Firebase
  void updateUserName(String newName) async {
    try {
      // Update name in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update({'name': newName});

      // Update name in Firebase Authentication
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(newName);
      }

      // Update the local state
      setState(() {
        currentUser?.name = newName;
        nameController.text = newName;
      });
      Fluttertoast.showToast(msg: "Name updated successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating name");
    }
  }
  void onImageUpdateSuccess() {
    fetchUserData(); // Fetch updated user data
  }

  Future<void> pickImageAndUpdateProfile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await authController.updateProfileImage(imageFile, onImageUpdateSuccess);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarySecondaryBackground,
      ),
      backgroundColor: AppColors.primarySecondaryBackground,
      body: Column(
        children: [
          GestureDetector(
            onTap: pickImageAndUpdateProfile,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Center(
                //   child: authController.isUpdatingProfileImage.value
                //       ? CircularProgressIndicator() // Show loading indicator
                //       : CircleAvatar(
                //     radius: 60,
                //     backgroundImage: currentUser?.image != null
                //         ? NetworkImage(currentUser!.image)
                //         : AssetImage('assets/user.png') as ImageProvider,
                //   ),
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     shape: BoxShape.circle,
                //   ),
                //   child: Icon(Icons.edit, color: Colors.black),
                // ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),

            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  GetBuilder<AuthenticationController>(
                    builder: (controller) {
                      return account_details_containter(
                        title: _auth.currentUser?.displayName ?? 'User Name',
                        leadingIcon: Icons.person,
                        onTap: () => _editUserName(context),
                      );
                    },
                  ),
                  account_details_containter(
                    title: 'Reset Password',
                    leadingIcon: Icons.lock_reset,
                    onTap: () => authController.resetPassword(
                        currentUser?.email ?? '', context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editUserName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "New Name"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Update Name'),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      await authController
                          .updateUserName(nameController.text.trim());
                     // Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
