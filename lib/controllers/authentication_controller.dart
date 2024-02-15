import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_reels/routes/name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global.dart';
import '../models/user.dart' as userModel;
import '../utils/toast_info.dart';

class AuthenticationController extends GetxController {
  final RxBool isUpdatingProfileImage = RxBool(false);

  Rx<User?> _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  // Other properties remain unchanged
  static AuthenticationController instanceAuth = Get.find();
  final Rx<File?> _pickedFile = Rx<File?>(null);
  File? get profileImage => _pickedFile.value;

  // Use this getter to safely access the current user
  User? get user => _currentUser.value;

  // Method to reset the image
  void resetImage() {
    _pickedFile.value = null;
    update(); // Notify listeners
  }

  Future<void> updateUserName(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({'name': newName});

      // Ensure the local user object is updated
      _currentUser.value = user;

      // Notify listeners to rebuild
      update();
    }}
    Future<void> updateProfileImage(File imageFile, Function onSuccess) async {
      isUpdatingProfileImage.value = true; // Start loading
      try {
        String imageUrl = await uploadedImagetoStorage(imageFile);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({'image': imageUrl});
          _currentUser.value = user;
          onSuccess(); // Call the callback function
        }
      } catch (e) {
        print("Error updating profile image: $e");
        // Handle errors
      } finally {
        isUpdatingProfileImage.value = false; // Stop loading
        update(); // Notify listeners
      }
    }

  Future<void> resetPassword(String email, context) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    toastInfo(msg: "Password reset email sent.", context: context);
  }

  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      _pickedFile.value = File(pickedImageFile.path); // Update the _pickedFile
      update(); // This will update all GetBuilder<AuthenticationController>()
    }
  }

  void captureImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      _pickedFile.value = File(pickedImageFile.path); // Update the _pickedFile
      update(); // This will update all GetBuilder<AuthenticationController>()
    }
  }

  Future<void> createAccountForNewUser(File imageFile, String userName,
      String userEmail, String userPassword, BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      toastInfo(
          msg:
          "Verification email has been sent. Please check your email inbox.",
          context: context);


      String imageUrl = await uploadedImagetoStorage(imageFile);

      userModel.User newUser = userModel.User(
        name: userName,
        uid: userCredential.user!.uid,
        image: imageUrl,
        email: userEmail,
      );

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .set(newUser.toJson());
        await userCredential.user!.sendEmailVerification();

        // Display a message to the user after the verification email is sent


        // Navigate to the login screen
        Get.offAllNamed(AppRoutes.signInOption); // Replace with the actual route name of your login screen

      } catch (e) {
        print("Error writing to Firestore: $e");

      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      String errorMessage = "An error occurred";
      switch (e.code) {
        case "weak-password":
          errorMessage = "Your password is not strong enough.";
          break;
        case "email-already-in-use":
          errorMessage =
          "There already exists an account with the given email address.";
          break;
        case "invalid-email":
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }
      toastInfo(msg: errorMessage, context: context);
    } catch (e) {
      // Handle other exceptions
      toastInfo(msg: "An error occurred. Please try again.", context: context);
    }
  }

  Future<String> uploadedImagetoStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("Profile Image")
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrlOfImage = await taskSnapshot.ref.getDownloadURL();
    return downloadUrlOfImage;
  }
  //
  // void login(String userEmail, String userPassword) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword);
  //     Get.snackbar("Login", "You are successfully login");
  //   } catch (error) {
  //     Get.snackbar("Login", "Un successful");
  //     // Get.to(SignUpScreen());
  //   }
  // }
  void signOut() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;


    if (user != null) {
      try {
        // Determine the provider based on the list of user's provider data
        String? providerId = user.providerData[0].providerId;

        // Handle sign out based on the provider
        if (providerId == 'google.com') {
          // Sign out from Google
          await GoogleSignIn().signOut();
        } else if (providerId == 'facebook.com') {
          // Sign out from Facebook
          await FacebookAuth.instance.logOut();
        }

        // Finally, sign out from Firebase
        await FirebaseAuth.instance.signOut();

        // Update shared preferences to reflect logout
        await Global.storageServices.logout(); // Or your equivalent method to remove the login token or status

        // Optionally, you can also reset the first open flag if needed
        // await Global.storageServices.setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, false);

        // Provide feedback to the user
        Get.snackbar("Login", "Successfully signed out");
        Get.offNamedUntil(AppRoutes.signInOption, (route) => false);

        // Navigate back to sign-in page or another appropriate screen
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     AppRoutes.signIn, (Route<dynamic> route) => false);

      } catch (e) {
        // Handle any errors during sign-out
        Get.snackbar("Login", "Error during sign-out");

      }
    }
  }


  void gotoScreen(User? currentUser) {
    if (currentUser == null) {
      // If no current user, go to the initial route (probably a welcome or sign-in screen)
      Get.offAllNamed(AppRoutes.initial);
    } else {
      // Check if the user's email is verified
      if (currentUser.emailVerified) {
        // If email is verified, navigate to the application's main screen
        Get.offAllNamed(AppRoutes.application);
      } else {
        // If email is not verified, navigate to the sign-in screen
        Get.offAllNamed(AppRoutes.signInOption);
      }
    }
  }


  @override
  void onReady() {
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, gotoScreen);
  }
}
