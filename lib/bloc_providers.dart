
import 'package:flick_reels/screens/authentication/register/bloc/register_bloc.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:flick_reels/screens/discover/bloc/discvoer_bloc.dart';
import 'package:flick_reels/screens/script_generator/bloc/script_bloc.dart';
import 'package:flick_reels/screens/splash_screen/bloc/splash_bloc.dart';
import 'package:flick_reels/screens/welcome/bloc/welcome_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProviders {

  static get allBlocProvider => [
    BlocProvider(create: (BuildContext context) => SplashBloc(),),
    BlocProvider(create: (BuildContext context) => WelcomeBloc(),),
    BlocProvider(create: (BuildContext context) => SignInBloc()),
    BlocProvider(create: (BuildContext context) => RegisterBloc()),
    BlocProvider(create: (BuildContext context) => DiscoverBloc()),
    BlocProvider(create: (BuildContext context) => ScriptBloc()),

  ];
}
