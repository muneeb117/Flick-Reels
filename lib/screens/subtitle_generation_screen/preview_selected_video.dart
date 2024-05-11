import 'dart:convert';
import 'dart:io';
import 'package:flick_reels/components/gradient_text.dart';
import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/subtitle_constants/subtitle_constants.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/subtitle_widget/progress_indicator.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import 'edit_subtitle_screen.dart';
import 'language_selection/language_selection_screen.dart';
import 'package:http/http.dart' as http;

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;

  VideoPreviewScreen({super.key, required this.videoPath});

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  String? _taskType = 'translate';
  String _languageCode = 'en'; // Default to English
  String? _selectedLanguage = 'English';
  bool _isFetchingSubtitles = false; // Flag to show loading spinner
  bool _isTranslate = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true); // Set the video to loop
        _controller.play(); // Start playing
        _isPlaying = true;
      });
  }

  void _sendDataToBackend() async {
    setState(() {
      _isFetchingSubtitles = true; // Start fetching subtitles, show spinner
    });

    var uri = Uri.parse('http://172.20.4.226:5000/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['task_type'] = _taskType ?? 'transcribe'
      ..fields['target_language'] = _languageCode
      ..files.add(await http.MultipartFile.fromPath('file', widget.videoPath));

    try {
      var response = await request.send();
      print('sending');
      if (response.statusCode == 200) {
        // print(response);
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        var subtitlesJson = jsonResponse['subtitles'];

        List<Map<String, dynamic>> subtitles =
            List<Map<String, dynamic>>.from(subtitlesJson.map((subtitle) => {
                  'start': subtitle['start'].toDouble(),
                  'end': subtitle['end'].toDouble(),
                  'text': subtitle['text'],
                }));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerWithSubtitlesScreen(
              videoPath: widget.videoPath,
              subtitles: subtitles,
              isTranslate: _isTranslate,
            ),
          ),
        );
      } else {
        print('Failed to generate subtitles');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to generate subtitles. Server responded with status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while generating subtitles: $e')),
      );
    } finally {
      setState(() {
        _isFetchingSubtitles = false; // Fetching complete, hide spinner
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon:const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Preview',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 460.h,
                        color: Colors.black,
                        child: Center(
                          child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                // Align stack contents to bottom center
                                children: [
                                  VideoPlayer(_controller), // The video player itself
                                  _buildPlayPauseOverlay(), // Play/Pause overlay
                                  _buildVideoProgressIndicator(), // Video progress indicator
                                ],
                              )
                              // Loading indicator
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListTile(
                          tileColor: Color(0xff151515),
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                  color: AppColors.primaryBackground)),
                          title: const Text(
                            'Select Language',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.containerStroke,
                                fontSize: 14),
                          ),
                          subtitle: Text(
                            _selectedLanguage!,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LanguageSelectionScreen(
                                  onLanguageSelected:
                                      (String languageCode, String taskType) {
                                    // This callback is not needed anymore since we're using Navigator.pop with result.
                                  },
                                  initialLanguageCode: _languageCode,
                                  initialIsTranslate: _isTranslate,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                _languageCode = result['languageCode'];
                                _taskType = result['taskType'];
                                _isTranslate = result['isTranslate'];
                                _selectedLanguage = _taskType == 'translate'
                                    ? 'English'
                                    : LanguageMap.getLanguageName(
                                        _languageCode);
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      defaultButton(
                        onTap: _selectedLanguage !=
                                null // Check if a language has been selected
                            ? () {
                                setState(() {
                                  _controller.pause(); // Pause the video
                                  _isPlaying =
                                      false; // Update the playing state
                                });
                                _sendDataToBackend(); // Send the data to the backend
                              }
                            : null, // Disable the button if no language is selected
                        text: 'Add Captions',
                        color: Colors.blue,
                        labelColor: Colors.white,
                      ),
                    ],
                  ),
                )
              : const SpinKitWave(
                  size: 40,
                  color: Colors.white,
                ),
          if (_isFetchingSubtitles)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                ), // Dim the background
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 50), // Adjust according to screen width
                      padding: EdgeInsets.all(20), // Uniform padding
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          // Optional: add shadow for a subtle depth effect
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          GradientText(
                            text: 'Generating captions with AI...',
                            colors: [Colors.blue, Colors.purple],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    // Make the entire container clickable.
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          // Toggle play/pause state.
          _isPlaying = !_isPlaying;
        });
      },
      // Display the play icon only when the video is paused.
      child: Container(
        color: Colors.transparent, // Make it invisible but clickable.
        child: Center(
          child: _isPlaying
              ? null
              : Icon(Icons.play_arrow_rounded, size: 45, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildVideoProgressIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
                _isPlaying = !_isPlaying;
              });
            },
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final Offset localOffset =
                    box.globalToLocal(details.globalPosition);
                final double dragPosition = localOffset.dx / box.size.width;
                final Duration position = Duration(
                  milliseconds:
                      (dragPosition * _controller.value.duration.inMilliseconds)
                          .round(),
                );
                _controller.seekTo(position);
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      colors: VideoProgressColors(
                        playedColor: Color(0xff706bba),
                        bufferedColor: Colors.white.withOpacity(0.3),
                        backgroundColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: VideoProgressIndicatorPainter(
                        videoController: _controller,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
