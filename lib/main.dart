import 'package:flick_reels/routes/page.dart';
import 'package:flick_reels/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'Controllers/authentication_controller.dart';
import 'global.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Global.init();

  Get.put(AuthenticationController()); // Instantiating the controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AppPage.allBlocProviders(context)],
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppPage.generateRouteSettings,
              theme: ThemeData(

                textTheme: customUrbanistTextTheme(ThemeData.light().textTheme),
                // Define other theme properties as needed
              ));
        },
      ),
    );
  }
}
