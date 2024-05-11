import 'dart:io';
import 'package:flick_reels/screens/Video_Editor/widgets/export_result.dart';
import 'package:flick_reels/screens/audio_enhancemnet/audio_enhancement_screen.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/preview_selected_video.dart';
import 'package:flick_reels/screens/video_editor/widgets/continue_button.dart';
import 'package:flick_reels/screens/video_editor/widgets/export_service.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:helpers/helpers.dart' show OpacityTransition;
import 'package:video_editor/video_editor.dart';
import '../upload_video/confirm_video_screen.dart';
import 'crop.dart';
import 'package:path_provider/path_provider.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({
    super.key,
    required this.file,
    this.withoutSubtitlePath,
    this.noisyAudioPath,
    this.subtitleGenerated = false,
    this.audioEnhanced = false,
  });

  final File file;
  final File? withoutSubtitlePath;
  final File? noisyAudioPath;

  final bool subtitleGenerated;

  final bool audioEnhanced;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  bool _isProgressDialogShowing = false;
  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 60),
  );

  @override
  void initState() {
    super.initState();
    _controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    ExportService.dispose();
    super.dispose();
  }
  // void _disposeVideoController() {
  //   if (_controller != null) {
  //     _controller.video.pause(); // Pause the video
  //     _controller.dispose(); // Dispose the controller
  //     _controller = null; // Set the controller to null
  //   }
  // }


  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors
            .green, // Optional: Change the background color to indicate success
      ),
    );
  }

  void _showErrorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
  void _exportAndNavigate() async {
    _isExporting.value = true;
    _exportingProgress.value = 0; // Reset progress to 0%

    final config = VideoFFmpegVideoEditorConfig(_controller);
    final FFmpegVideoEditorExecute execute = await config.getExecuteConfig();

    if (!_isProgressDialogShowing) {
      _showProgressDialog(context); // Show progress dialog at the center
    }

    ExportService.runFFmpegCommand(
      execute,
      onProgress: (stats) {
        double progress = config.getFFmpegProgress(stats.getTime().toInt());
        _exportingProgress.value =
            progress.clamp(0.0, 1.0); // Ensure progress is between 0 and 1
        // If you need to update the UI (e.g., a progress bar), call setState here
      },
      onError: (e, s) {
        _closeProgressDialog(); // Close the progress dialog on error
        _showErrorSnackBar("Error on export video :(");
      },
      onCompleted: (file) {
        _closeProgressDialog(); // Close the progress dialog on completion
        if (!mounted) return;

        // Navigate to the next screen with the exported video file
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfirmVideoScreen(videoFile: file, videoPath: file.path),
          ),
        );
      },
    );
  }

  void _exportAndDownload() async {
    _exportingProgress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(_controller);
    final FFmpegVideoEditorExecute execute = await config.getExecuteConfig();

    _showProgressDialog(context); // Show progress dialog

    ExportService.runFFmpegCommand(
      execute,
      onProgress: (stats) {
        _exportingProgress.value =
            config.getFFmpegProgress(stats.getTime().toInt());
        // Handle progress UI update here
      },
      onError: (e, s) {
        Navigator.pop(context); // Dismiss the progress dialog
        _showErrorSnackBar("Error on export video :(");
        _isExporting.value = false;
      },
      onCompleted: (file) async {
        Navigator.pop(context); // Dismiss the progress dialog
        _isExporting.value = false;
        if (!mounted) return;

        // Use GallerySaver to save the video to the gallery
        final bool? isSaved = await GallerySaver.saveVideo(
          file.path,
        );

        if (isSaved == true) {
          _showSuccessSnackBar("Video saved to Gallery");
        } else {
          _showErrorSnackBar("Failed to save video to Gallery");
        }
      },
    );
  }

  void _exportCover() async {
    final config = CoverFFmpegVideoEditorConfig(_controller);
    final execute = await config.getExecuteConfig();
    if (execute == null) {
      _showErrorSnackBar("Error on cover exportation initialization.");
      return;
    }

    await ExportService.runFFmpegCommand(
      execute,
      onError: (e, s) => _showErrorSnackBar("Error on cover exportation :("),
      onCompleted: (cover) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => CoverResultPopup(cover: cover),
        );
      },
    );
  }

  void _showProgressDialog(BuildContext context) {
    if (!_isProgressDialogShowing) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from closing on tap
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                ValueListenableBuilder<double>(
                  valueListenable: _exportingProgress,
                  builder: (context, value, child) {
                    return Text(
                        '${(value * 100).toStringAsFixed(0)}% Completed');
                  },
                ),
              ],
            ),
          );
        },
      );
      _isProgressDialogShowing = true;
    }
  }

  void _closeProgressDialog() {
    if (_isProgressDialogShowing) {
      Navigator.pop(context); // Dismiss the progress dialog
      _isProgressDialogShowing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              buildContinueButton(_exportAndNavigate),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CropGridViewer.preview(
                                              controller: _controller),
                                          AnimatedBuilder(
                                            animation: _controller.video,
                                            builder: (_, __) =>
                                                OpacityTransition(
                                              visible: !_controller.isPlaying,
                                              child: GestureDetector(
                                                onTap: _controller.video.play,
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration:
                                                      const BoxDecoration(
                                                    // color: Colors.black,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/play.png")),
                                                    // shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CoverViewer(controller: _controller)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 280,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        child: TabBar(
                                          indicatorColor: Colors.white,
                                          dividerColor: Colors.transparent,
                                          indicatorPadding: EdgeInsets.only(
                                              left: 50, right: 40),
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          indicatorWeight: 1.5,
                                          tabs: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                          Icons.content_cut,
                                                          color: Colors.white,
                                                          size: 20)),
                                                  Text('Trim',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15))
                                                ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                        Icons.video_label,
                                                        color: Colors.white,
                                                        size: 20)),
                                                Text(
                                                  'Cover',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Column(
                                              // mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: _trimSlider(),
                                            ),
                                            _coverSelection(),
                                          ],
                                        ),
                                      ),
                                      bottomNavbar(),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget bottomNavbar() {
    return SafeArea(
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Close Caption Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _controller.video.pause();

                      // Navigate to the Video Editor screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPreviewScreen(
                                videoPath: widget.file.path)),
                      );
                    },
                    icon: const Icon(Icons.closed_caption_off_rounded,
                        color: Colors.white),
                    tooltip: 'Close Caption',
                  ),
                  const Text('Caption', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            // Rotate Left Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () =>
                        _controller.rotate90Degrees(RotateDirection.left),
                    icon: const Icon(Icons.rotate_left, color: Colors.white),
                    tooltip: 'Rotate unclockwise',
                  ),
                  const Text('Left', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            // Rotate Right Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () =>
                        _controller.rotate90Degrees(RotateDirection.right),
                    icon: const Icon(Icons.rotate_right, color: Colors.white),
                    tooltip: 'Rotate clockwise',
                  ),
                  const Text('Right', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            // Crop Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => CropPage(controller: _controller),
                      ),
                    ),
                    icon: const Icon(Icons.crop, color: Colors.white),
                    tooltip: 'Open crop screen',
                  ),
                  const Text('Crop', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            // Sound Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35, // Adjust this height as needed
                    child: GestureDetector(
                      onTap: () {
                        _controller.video.pause();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioEnhancementScreen(
                                videoPath: widget.file.path.toString()),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 20,
                          width: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/sound.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20, // Adjust this height as needed
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Denoise',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            // Save Video Icon
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton(
                    tooltip: 'Save Video',
                    icon: const Icon(Icons.file_download_outlined,
                        color: Colors.white),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: _exportCover,
                        child: const Text('Export cover'),
                      ),
                      PopupMenuItem(
                        onTap: _exportAndDownload,
                        child: const Text('Export video'),
                      ),
                    ],
                  ),
                  const Text('Save', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt())),
                  style: const TextStyle(color: Colors.white)),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    formatter(_controller.startTrim),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim),
                      style: const TextStyle(color: Colors.white)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            textStyle: const TextStyle(color: Colors.white),
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }

  Widget _coverSelection() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: CoverSelection(
            controller: _controller,
            size: height + 10,
            quantity: 8,
            selectedCoverBuilder: (cover, size) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  cover,
                  Icon(
                    Icons.check_circle,
                    color: const CoverSelectionStyle().selectedBorderColor,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
