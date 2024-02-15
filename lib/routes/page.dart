import 'package:flick_reels/screens/application/bloc/app_bloc.dart';
import 'package:flick_reels/screens/authentication/ForgotPassword/forgot_notification.dart';
import 'package:flick_reels/screens/authentication/register/register_screen.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:flick_reels/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:flick_reels/screens/discover/bloc/discvoer_bloc.dart';
import 'package:flick_reels/screens/discover/discover_screen.dart';
import 'package:flick_reels/screens/search/search_screen.dart';
import 'package:flick_reels/screens/splash_screen/bloc/splash_bloc.dart';
import 'package:flick_reels/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';
import '../screens/application/application_page.dart';
import '../screens/authentication/ForgotPassword/forgot_password.dart';
import '../screens/authentication/register/bloc/register_bloc.dart';
import '../screens/authentication/sign_in_option/sign_in_option_screen.dart';
import '../screens/welcome/bloc/welcome_bloc.dart';
import '../screens/welcome/welcome_screen.dart';
import 'name.dart';

class AppPage {
  static List<PageEntity> routes = [
    PageEntity(
      route: AppRoutes.initial,
      page: const SplashScreen(),
      bloc: BlocProvider(
        create: (_) => SplashBloc(),
      ),
    ),
    PageEntity(
      route: AppRoutes.welcome,
      page: const WelcomeScreen(),
      bloc: BlocProvider(
        create: (_) => WelcomeBloc(),
      ),
    ),
    PageEntity(
      route: AppRoutes.signInOption,
      page: SignInOptionScreen(),
    ),

    PageEntity(
      route: AppRoutes.signIn,
      page: const SignInScreen(),
      bloc: BlocProvider(
        create: (_) => SignInBloc(),
      ),
    ),
    PageEntity(
      route: AppRoutes.register,
      page: const RegistrationScreen(),
      bloc: BlocProvider(
        create: (_) => RegisterBloc(),
      ),
    ),
    PageEntity(
      route: AppRoutes.forgetPassword,
      page: ForgotPasswordPage(),
    ),
    PageEntity(
      route: AppRoutes.forgetNotification,
      page: ForgotNotificationScreen(),
    ),
    PageEntity(
      route: AppRoutes.search,
      page:  SearchScreen(),

    ),

    PageEntity(
      route: AppRoutes.application,
      bloc: BlocProvider(
        create: (_) => AppBlocs(),
      ),
      page: const ApplicationPage(),
    ),
    PageEntity(
      route: AppRoutes.discover,
      bloc: BlocProvider(
        create: (_) => DiscoverBloc(),
      ),
      page: const DiscoverScreen(),
    ),


  ];

  static List<BlocProvider> allBlocProviders(BuildContext context) {
    List<BlocProvider> blocProviders = <BlocProvider>[];
    for (var bloc in routes) {
      if (bloc.bloc != null) {
        blocProviders.add(bloc.bloc as BlocProvider);
      }
    }
    return blocProviders;
  }

  //model that covers entire screen
  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      var result = routes.where((element) => element.route == settings.name);
      if (result.isNotEmpty) {
        bool deviceFirstOpen = Global.storageServices.getDeviceFirstOpen();
        if (result.first.route == AppRoutes.initial && deviceFirstOpen) {
          bool isloggedIn = Global.storageServices.getIsLoggedIn();
          if (isloggedIn) {
            return MaterialPageRoute(
                builder: (_) => ApplicationPage(), settings: settings);
          }
          return MaterialPageRoute(
              builder: (_) => SignInOptionScreen(), settings: settings);
        }
        return MaterialPageRoute(
            builder: (_) => result.first.page, settings: settings);
      }
    }
    print("invalid route name ${settings.name}");
    return MaterialPageRoute(
        builder: (_) => SplashScreen(), settings: settings);
  }
}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;
  PageEntity({required this.route, required this.page, this.bloc});
}
