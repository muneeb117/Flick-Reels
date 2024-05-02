import 'package:audioplayers/audioplayers.dart';
import 'package:flick_reels/components/gradient_text.dart';
import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flick_reels/screens/voice_over/pexel_template/template_selection.dart';
import 'package:flick_reels/screens/voice_over/video_player_page.dart';
import 'package:flick_reels/screens/voice_over/widgets/all_avatars.dart';
import 'package:flick_reels/screens/voice_over/widgets/see_all.dart';
import 'package:flick_reels/screens/voice_over/widgets/selectableAvatar.dart';
import 'package:flick_reels/screens/voice_over/widgets/voice_data.dart';
import 'package:flick_reels/services/voice_over_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/reusable_script_container.dart';
import '../../services/voice_over_utlility.dart';
import '../../utils/colors.dart';

class VoiceOver extends StatefulWidget {
  const VoiceOver({super.key});

  @override
  State<VoiceOver> createState() => _VoiceOverState();
}

class _VoiceOverState extends State<VoiceOver> {
  bool _isAIGenerated = false;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _scriptController = TextEditingController();
  final TextEditingController _manualTextController = TextEditingController();
  String? _selectedVoice;
  String? _generatedAudioPath;
  String? _selectedVideoPath;
  bool _isLoading = false; // State to manage loading

  VoiceOverUtility? _voiceOverUtility;

  @override
  void initState() {
    super.initState();
    _voiceOverUtility = VoiceOverUtility(
        apiKey: 'AIzaSyAh4sQ57SGO639U_7jVXum7jYXD0H1-_gg',
        audioPlayer: AudioPlayer());
  }

  Widget _buildScriptGenerator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ReusableScriptContainer(
                  hintText: 'Enter topic for AI-generated script',
                  controller: _topicController,
                  child: null,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 5.w),
              IconButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // Disable button when loading
                        setState(() {
                          _isLoading = true; // Start loading
                        });
                        var script = await VoiceOverScript()
                            .generateScript(_topicController.text);
                        setState(() {
                          _scriptController.text = script;
                          _isLoading = false; // Stop loading
                        });
                      },
                icon: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: Colors.black,
                          strokeWidth: 3.0,
                        ),
                      ) // Show loading indicator
                    : SizedBox(
                        height: 22,
                        width: 22,
                        child: Image.asset(
                          'assets/send.png',
                          color: Colors.black,
                        )), // Custom send icon
                iconSize: 24.w, // Custom icon size
              )
            ],
          ),
          SizedBox(height: 10.h),
          ReusableScriptContainer(
            hintText: 'Generated script will appear here...',
            controller: _scriptController,
            child: null,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildManualTextEntry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ReusableScriptContainer(
        hintText: 'Type your text here',
        controller: _manualTextController,
        child: null,
        maxLines: 3,
      ),
    );
  }

  void _openTemplateSelection() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TemplateSelection(onVideoSelected: (path) {
                  setState(() {
                    _selectedVideoPath = path;
                  });
                  // handleVoiceOverProcess(path);  // Automatically start the voice-over process with the selected video path
                })));
  }

  void handleVoiceOverProcess(String videoPath) async {
    await _voiceOverUtility!.requestPermissions();
    _selectedVideoPath = videoPath;

    String textToConvert =
        _isAIGenerated ? _scriptController.text : _manualTextController.text;
    if (textToConvert.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter or generate text")));
      return;
    }

    _generatedAudioPath = await _voiceOverUtility!.convertTextToSpeech(
        textToConvert, _selectedVoice ?? 'en-US-Wavenet-F');
    if (_generatedAudioPath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to generate audio")));
      return;
    }

    String outputVideoPath = await _voiceOverUtility!
        .mergeAudioAndVideo(_generatedAudioPath!, _selectedVideoPath!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoPlayPage(
                videoPath: outputVideoPath, subtitleText: textToConvert)));
  }

  Widget buildVoiceSelector() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: voices.length,
            itemBuilder: (BuildContext context, int index) {
              var voice = voices[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVoice = voice.voiceId;
                  });
                },
                child: Column(
                  children: [
                    SelectableAvatar(
                      imageProvider: voice.avatarImage,
                      isSelected: _selectedVoice == voice.voiceId,
                      onTap: () {
                        setState(() {
                          _selectedVoice = voice.voiceId;
                        });
                      },
                      backgroundColor: voice.backgroundColor,
                    ),
                    SizedBox(height: 5),
                    Text(voice.name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600))
                  ],
                ),
              );
            },
          ),
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAvatarsPage(
                            onSelectAvatar: (voiceId, backgroundColor) {
                              setState(() {
                                _selectedVoice = voiceId;
                              });
                            },
                          )));
            },
            child: See_All())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text(
          'Voice Over',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                hoverColor: Colors.transparent,
                inactiveThumbColor: Colors.black45,
                inactiveTrackColor: Colors.white10,
                activeTrackColor: Color(0xff706bba),
                activeColor: Colors.white,
                title: GradientText(
                  colors: _isAIGenerated
                      ? [Colors.purple, Colors.blue]
                      : [AppColors.primaryBackground, Colors.purple],
                  text: _isAIGenerated
                      ? 'Script Generated in AI'
                      : 'Generate Script in AI',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                value: _isAIGenerated,
                onChanged: (bool value) {
                  setState(() {
                    _isAIGenerated = value;
                  });
                },
              ),
            ),
            _isAIGenerated ? _buildScriptGenerator() : _buildManualTextEntry(),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: buildVoiceSelector(),
            ),
            SizedBox(height: 40),

            defaultButton(
              onTap: _openTemplateSelection,
              color: AppColors.primaryBackground,
              text: 'Select Template',
              labelColor: Colors.white,
            ),
            SizedBox(height: 20),
            defaultButton(
                icon: Icons.slow_motion_video_rounded,
                onTap: () {
                  handleVoiceOverProcess(_selectedVideoPath!);
                },
                color: Colors.teal,
                text: 'Play Voice Over',
                labelColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
