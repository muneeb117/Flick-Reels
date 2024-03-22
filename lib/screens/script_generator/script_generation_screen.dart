import 'package:flick_reels/screens/script_generator/script_edit_screen.dart';
import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flick_reels/screens/script_generator/widgets/reusable_script_container.dart';
import 'package:flick_reels/screens/script_generator/widgets/reusable_text_widget.dart';
import 'package:flick_reels/screens/script_generator/widgets/text_with_icon.dart';
import 'package:flick_reels/utils/toast_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../utils/colors.dart';
import 'bloc/script_bloc.dart';
import 'bloc/script_events.dart';
import 'bloc/script_states.dart';

class ScriptGeneratorScreen extends StatelessWidget {
  const ScriptGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScriptGenerationBloc(),
      child: _ScriptGeneratorView(),
    );
  }
}

class _ScriptGeneratorView extends StatefulWidget {
  @override
  __ScriptGeneratorViewState createState() => __ScriptGeneratorViewState();
}

class __ScriptGeneratorViewState extends State<_ScriptGeneratorView> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _keyPointController = TextEditingController();
  String _selectedTone = '';
  final List<String> _tones = [
    'Professional',
    'Casual',
    'Serious',
    'Humorous',
    'Cheerful'
  ];
  @override
  void initState() {
    super.initState();

    // Add listener to _keyPointController
    _keyPointController.addListener(() {
      // Trigger rebuild whenever text changes
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Script Generator',style: TextStyle(fontWeight: FontWeight.w600),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ScriptGenerationBloc, ScriptGenerationState>(
          listener: (context, state) {
            if (state is ScriptGenerationLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(

                    width: 250.w, height: 220.h,
                        child: Lottie.asset('assets/json_animation/script_loading.json',
                           ),
                      ),
                      SizedBox(height: 10.h,),
                      const Text("Generating Script...",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                      SizedBox(height: 40.h,),

                    ],
                  ),
                ),
              );
            } else if (state is ScriptGenerationLoaded) {
              Navigator.pop(context); // Close the loading dialog
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ScriptEditScreen(script: state.script)));
            } else if (state is ScriptGenerationError) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const text_with_icon_row(
                  text: 'Topic',
                  icon: 'pencil (1)',
                ),
                SizedBox(height: 10.h),
                ReusableScriptContainer(
                  hintText: 'Write topic e.g Climate Change',
                  controller: _topicController,
                  maxLines: 3,
                  child: null,
                ),
                SizedBox(height: 20.h),
                const text_with_icon_row(
                  text: 'Key Points',
                  icon: 'right-arrow',
                ),
                SizedBox(height: 10.h),
                ReusableScriptContainer(
                  hintText: 'Write key Points that you want to include in script',
                  controller: _keyPointController,
                  maxLines: 3,
                  child: _keyPointController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _keyPointController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                            color: AppColors.strokeColor,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: 20.h),
                const reusable_scipt_text(text: 'Select Tone'),
                buildToneSelection(),
                SizedBox(height: 40.h),
                buildScriptButton(
                  onTap: () {
                    if (_topicController.text.isNotEmpty) {
                      BlocProvider.of<ScriptGenerationBloc>(context).add(
                        GenerateScriptEvent(
                          topic: _topicController.text,
                          keyPoints: _keyPointController.text,
                          tone: _selectedTone,
                        ),
                      );
                    } else {
                      toastInfo(context: context, msg: 'Please enter a topic.');
                    }
                  },
                  color: AppColors.primaryBackground,
                  text: 'Generate Script',
                  labelColor: Colors.white,
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildToneButton(String tone) {
    bool isSelected = _selectedTone == tone;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FilterChip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
                color: isSelected
                    ? AppColors.primaryBackground
                    : AppColors.strokeColor,
                width: 1.0)),
        label: Text(tone),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedTone = selected ? tone : '';
          });
        },
        backgroundColor:
            isSelected ? AppColors.primaryBackground : Colors.white,
        selectedColor: AppColors.primaryBackground,
        showCheckmark: false,
        avatarBorder: const CircleBorder(
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildToneSelection() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tones.length,
        itemBuilder: (BuildContext context, int index) {
          return buildToneButton(_tones[index]);
        },
      ),
    );
  }
}
