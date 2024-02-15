import 'package:flick_reels/screens/splash_screen/bloc/splash_event.dart';
import 'package:flick_reels/screens/splash_screen/bloc/splash_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashScreenEvent,SplashScreenState>{
  SplashBloc():super(SplashScreenState()){
    on<UpdateRotation>((event, emit) {
      emit(SplashScreenState(rotationAngle:event.angle));
    });
  }

}