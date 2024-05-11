import 'dart:io';
import 'package:flick_reels/components/gradient_text.dart';
import 'package:flick_reels/screens/Video_Editor/videoEditor_screen.dart';
import 'package:flick_reels/screens/script_generator/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import '../../services/audio_utility.dart';
import '../../utils/colors.dart';
import '../subtitle_generation_screen/subtitle_widget/progress_indicator.dart'; // Ensure this service handles HTTP requests and FFmpeg commands

class AudioEnhancementScreen extends StatefulWidget {
  final String videoPath;

  const AudioEnhancementScreen({super.key, required this.videoPath});

  @override
  _AudioEnhancementScreenState createState() => _AudioEnhancementScreenState();
}

class _AudioEnhancementScreenState extends State<AudioEnhancementScreen> {
  VideoPlayerController? _videoController;
  String? _originalVideoPath;
  String? _enhancedVideoPath;
  bool _isProcessing = false;
  bool _audioEnhanced = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadVideo(widget.videoPath);
  }

  Future<void> _loadVideo(String videoPath) async {
    if (widget.videoPath != null) {
      _disposeVideoController();
      setState(() {
        _isProcessing = true;
        _audioEnhanced = false;
        _originalVideoPath = widget.videoPath;
      });
      String? audioPath = await AudioUtility.uploadVideoAndGetEnhancedAudio(
          File(_originalVideoPath!));
      if (audioPath != null) {
        _enhancedVideoPath = await AudioUtility.mergeAudioAndVideo(
            audioPath, _originalVideoPath!);
        _initializeVideoPlayer(_enhancedVideoPath!, enhanced: true);
      } else {
        _initializeVideoPlayer(_originalVideoPath!, enhanced: false);
      }
    }
  }

  Future<void> _pickAndUploadVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _disposeVideoController();
      setState(() {
        _isProcessing = true;
        _audioEnhanced = false;
        _originalVideoPath = pickedFile.path;
      });
      String? audioPath = await AudioUtility.uploadVideoAndGetEnhancedAudio(
          File(_originalVideoPath!));
      if (audioPath != null) {
        _enhancedVideoPath = await AudioUtility.mergeAudioAndVideo(
            audioPath, _originalVideoPath!);
        _initializeVideoPlayer(_enhancedVideoPath!, enhanced: true);
      } else {
        _initializeVideoPlayer(_originalVideoPath!, enhanced: false);
      }
    }
  }

  void _initializeVideoPlayer(String videoPath, {required bool enhanced}) {
    _disposeVideoController(); // Dispose existing controller
    _videoController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {
          _isProcessing = false;
          _audioEnhanced = enhanced;
          _isPlaying = true;
        });
        _videoController!.play();
        _videoController!.setLooping(true);
      });

    // Adding listener to update UI as video plays
  }

  void _toggleAudioTrack() {
    bool shouldPlayEnhanced = !_audioEnhanced;
    String path =
        shouldPlayEnhanced ? _enhancedVideoPath! : _originalVideoPath!;
    _initializeVideoPlayer(path, enhanced: shouldPlayEnhanced);
  }

  void _disposeVideoController() {
    if (_videoController != null) {
      _videoController!.pause(); // Pause the video
      _videoController!.dispose(); // Dispose the controller
      _videoController = null; // Set the controller to null
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Audio Enhancement',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          if(_videoController != null)
          Padding(

            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(

              onPressed: () {
                _disposeVideoController();


                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => VideoEditor( file: File(_enhancedVideoPath!),)));

              },
              child: GradientText(
                colors: [Colors.purple, Colors.blue],
                text: 'Continue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.black,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors
                        .deepPurple), // Use a solid color for value color, the shader will overlay it.
                    strokeWidth: 5,
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  GradientText(
                    text: 'Enhancing Speech...',
                    colors: [Colors.blue, Colors.purple],
                    fontSize: 14.sp,
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_videoController != null &&
                          _videoController!.value.isInitialized)
                        SizedBox(
                          height: 460.h,
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoPlayer(_videoController!),
                                _buildPlayPauseOverlay(),
                                // _buildVideoProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (_videoController != null &&
                          _videoController!.value.isInitialized)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GradientText(
                                colors: _audioEnhanced
                                    ? [Colors.purple, Colors.blue]
                                    : [Colors.black87, Colors.black87],
                                text: _audioEnhanced
                                    ? 'Enhanced Audio'
                                    : 'Original Audio',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              Switch(
                                value: _audioEnhanced,
                                onChanged: _videoController != null
                                    ? (bool value) {
                                        _toggleAudioTrack();
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      defaultButton(
                          icon: Icons.file_upload_outlined,
                          onTap: _pickAndUploadVideo,
                          color: Colors.blue,
                          text: 'Denoise Other Video',
                          labelColor: Colors.white),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    // Make the entire container clickable.
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isPlaying) {
            _videoController!.pause();
          } else {
            _videoController!.play();
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
                  _videoController!.pause();
                } else {
                  _videoController!.play();
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
                  milliseconds: (dragPosition *
                          _videoController!.value.duration.inMilliseconds)
                      .round(),
                );
                _videoController!.seekTo(position);
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: VideoProgressIndicator(
                      _videoController!,
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
                        videoController: _videoController!,
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

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }
}
