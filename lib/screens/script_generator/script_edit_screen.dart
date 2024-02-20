import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        title: Text('Edit Script'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _scriptController.clear(); // Clear the script
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _scriptController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Your script appears here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to TeleprompterWidget with the potentially edited script
                Get.to(() => TeleprompterWidget(text: _scriptController.text));
              },
              child: Text('Teleprompt'),
            ),
          ],
        ),
      ),
    );
  }
}
