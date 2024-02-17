import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flick_reels/screens/script_generator/widgets/reusable_text_widget.dart';
import 'package:flick_reels/screens/teleprompting/src/teleprompter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/colors.dart';

class ScriptGeneratorScreen extends StatefulWidget {
  const ScriptGeneratorScreen({super.key});

  @override
  State<ScriptGeneratorScreen> createState() => _ScriptGeneratorScreenState();
}

class _ScriptGeneratorScreenState extends State<ScriptGeneratorScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _scriptController = TextEditingController();
  bool _isTopicButton = false;
  bool _isScriptButton = false;

  @override
  void initState() {
    super.initState();
    _topicController.addListener(() {
      if (_topicController.text.isNotEmpty && !_isTopicButton) {
        setState(() {
          _isTopicButton = true;
        });
      } else if (_topicController.text.isEmpty && _isTopicButton) {
        setState(() {
          _isTopicButton = false;
        });
      }
    });
    _scriptController.addListener(() {
      if (_scriptController.text.isNotEmpty && !_isScriptButton) {
        setState(() {
          _isScriptButton = true;
        });
      } else if (_scriptController.text.isEmpty && _isScriptButton) {
        setState(() {
          _isScriptButton = false;
        });
      }
    });
  }

  Future<void> generateScript(String topic) async {
    final scriptGeneratorApi = ScriptGeneratorApi();
    String script = await scriptGeneratorApi.generateScript(topic);
    setState(() {
      _scriptController.text = script;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Script Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const reusable_scipt_text(
                text: 'Topic',
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.strokeColor),
                ),
                child: TextFormField(
                  controller: _topicController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Enter Topic e.g., Climate Change',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.text_snippet_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              buildScriptButton(
                    () {
                  _isTopicButton ? generateScript(_topicController.text) : null;
                },
                _isTopicButton
                    ? AppColors.primaryBackground
                    : AppColors.strokeColor,
                'Genrate Script',
                _isTopicButton ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 20),
              const reusable_scipt_text(
                text: 'Script',
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.strokeColor),
                ),
                child: TextField(
                  controller: _scriptController,
                  decoration: InputDecoration(
                    hintText: _isTopicButton
                        ? 'Generated Script will here.....'
                        : 'Write Your Script or enter Topic To generate',
                    border: InputBorder.none,
                  ),
                  maxLines: 10,
                ),
              ),
              const SizedBox(height: 20),
              buildScriptButton(
                    () {
                  _isScriptButton
                      ? Get.to(TeleprompterWidget(
                    text: _scriptController.text.toString(),
                  ))
                      : null;
                },
                _isScriptButton
                    ? AppColors.primaryBackground
                    : AppColors.strokeColor,
                'Teleprompt',
                _isScriptButton ? Colors.white : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}