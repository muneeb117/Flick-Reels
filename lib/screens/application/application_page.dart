import 'package:flick_reels/screens/application/widgets/application_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_events.dart';
import 'bloc/app_states.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBlocs, AppStates>(builder: (context, state) {
      return Scaffold(
        body: buildPage(state.index),
        bottomNavigationBar: Container(

          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.h),
              topRight: Radius.circular(20.h),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: state.index == 0 ? Colors.black : Colors.white,
            unselectedItemColor:state.index == 0 ? Colors.white :Colors.grey ,
            selectedItemColor: AppColors.primaryBackground,
            selectedFontSize: 12.0,
            currentIndex: state.index,
            onTap: (value) {
              context.read<AppBlocs>().add(AppTriggeredEvents(value));
            },
            items: bottomTabs,
          ),
        ),
      );
    });
  }
}
