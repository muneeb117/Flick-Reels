
import 'package:firebase_core/firebase_core.dart';
import 'package:flick_reels/services/storage_services.dart';
import 'package:flick_reels/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';

class Global {
  static late StorageServices storageServices;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    storageServices = await StorageServices().init();

    // Check if the app is opened for the first time
    if (!storageServices.getDeviceFirstOpen()) {
      // If it's the first time, set the flag to true
      await storageServices.setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
    }
  }
}
