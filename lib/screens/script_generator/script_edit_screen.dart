import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flick_reels/components/reusable_script_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../teleprompting/src/teleprompter_widget.dart';

class ScriptEditScreen extends StatefulWidget {
  final String script;

  const ScriptEditScreen({Key? key, required this.script}) : super(key: key);

  @override
  _ScriptEditScreenState createState() => _ScriptEditScreenState();
}

class _ScriptEditScreenState extends State<ScriptEditScreen> {
  late TextEditingController _scriptController;

  @override
  void initState() {
    super.initState();
    _scriptController = TextEditingController(text: widget.script);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Script',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: AppColors.containerStroke,
              ),
              onPressed: () {
                _scriptController.clear(); // Clear the script
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(

              child: ReusableScriptContainer(
                hintText: 'Your Script Here',
                controller: _scriptController,
                maxLines: 50,
                child: null,
              ),

            ),
            SizedBox(height: 20),
            defaultButton(
                color: AppColors.primaryBackground,
                onTap: () {
                  Get.to(
                      () => TeleprompterWidget(text: _scriptController.text));
                },
                text: 'Teleprompt',
                labelColor: Colors.white)
            // ReusableButton(
            //   onPressed: () {
            //     // Navigate to TeleprompterWidget with the potentially edited script
            //     Get.to(() => TeleprompterWidget(text: _scriptController.text));
            //   },
            //   text: 'Teleprompt',
            // ),
          ],
        ),
      ),
    );
  }
}
