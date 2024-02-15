import 'package:flick_reels/screens/authentication/register/bloc/register_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Controllers/authentication_controller.dart';
import '../../../../utils/toast_info.dart';

class RegisterController{
 final BuildContext context;
 var authenticationController = AuthenticationController.instanceAuth;
 RegisterController({required this.context});

 Future<void> handleSignUp() async {
   final state = context
       .read<RegisterBloc>()
       .state;
   try {
     String email = state.email;
     String name = state.name;
     String password = state.password;
     String rePassword = state.rePassword;
     // String imageUrl = state.imageUrl;

     if (email.isEmpty) {
       toastInfo(msg: "Your need to fill email address", context: context);
       return;
     }
     if (name.isEmpty) {
       toastInfo(msg: "Your need to write your name", context: context);
       return;
     }
     if (password.isEmpty) {
       toastInfo(msg: "Your need to fill password address", context: context);
       return;
     }
     if (rePassword.isEmpty) {
       toastInfo(msg: "You Password confirmation is empty", context: context);
       return;
     }
     if (rePassword != password) {
       toastInfo(msg: "You confirm password is not matched", context: context);
       return;
     }
     if (authenticationController.profileImage==null) {
       toastInfo(msg: "Kindly Upload Image to proceed", context: context);
       return;
     }

     try {
       authenticationController.createAccountForNewUser(authenticationController.profileImage!, state.name, state.email, state.password,context);

     } catch (e) {
       toastInfo(context: context, msg: e.toString());

     }
   }
   catch (e) {

   }
 }}