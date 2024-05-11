import 'package:flick_reels/components/gradient_text.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/processed_screen.dart';
import 'package:flick_reels/screens/subtitle_generation_screen/subtitle_widget/play_pause_overlay.dart';
import 'package:flick_reels/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../models/subtitle_model.dart';

enum EditOptions { font, bgColor, textColor, editSubtitle }

class VideoPlayerWithSubtitlesScreen extends StatefulWidget {
  final String videoPath;
  final List<Map<String, dynamic>> subtitles;
  final bool isTranslate;

  const VideoPlayerWithSubtitlesScreen({
    Key? key,
    required this.videoPath,
    required this.subtitles,
    required this.isTranslate,
  }) : super(key: key);

  @override
  _VideoPlayerWithSubtitlesScreenState createState() =>
      _VideoPlayerWithSubtitlesScreenState();
}

class _VideoPlayerWithSubtitlesScreenState
    extends State<VideoPlayerWithSubtitlesScreen> {
  late VideoPlayerController _controller;
  late List<TextEditingController> _controllers;
  String _currentSubtitle = '';
  bool _isPlaying = true;
  Color bgColor = Colors.black;
  Color fgColor = Colors.white;

  TextStyle subtitleStyle = const TextStyle(color: Colors.white, fontSize: 16);
  String selectedFont = '';
  EditOptions selectedOption = EditOptions.editSubtitle;

  List<String> fonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Poppins',
    'Merriweather',
    'Montserrat',
    'Oswald',
    'Raleway',
    'Roboto Slab',
    'Permanent Marker',
    'Lobster',
    'Comfortaa',
    'Pacifico',
    'Dancing Script',
    'Bebas Neue',
    'Bungee Spice', // If Bungee Spice is not available on Google Fonts, you might need to get it from another source.
  ];
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    // ..setLooping(true);

    _controller.addListener(() {
      final currentPosition = _controller.value.position.inSeconds;
      for (int i = 0; i < widget.subtitles.length; i++) {
        final subtitle = widget.subtitles[i];
        if (currentPosition >= subtitle['start'] &&
            currentPosition <= subtitle['end']) {
          if (_currentSubtitle != subtitle['text']) {
            setState(() {
              _currentSubtitle = subtitle['text'];
            });
          }
          break;
        }
      }
    });

    _controllers = widget.subtitles
        .map((subtitle) => TextEditingController(text: subtitle['text']))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onColorChanged(Color color) {
    setState(() {
      if (selectedOption == EditOptions.bgColor) {
        bgColor = color;
      } else if (selectedOption == EditOptions.textColor) {
        fgColor = color;
        // Update the subtitleStyle with the new foreground color.
        subtitleStyle = subtitleStyle.copyWith(color: fgColor);
      }
    });
  }

  void _onFontChanged(String font) {
    setState(() {
      selectedFont = font;
      subtitleStyle = GoogleFonts.getFont(
        font,
        color: fgColor,
        fontSize: 16,
      );
    });
  }

  String _formatTime(double millis) {
    int totalSeconds = millis.round();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits((totalSeconds ~/ 60) % 60);
    String twoDigitSeconds = twoDigits(totalSeconds % 60);
    return "${twoDigits(totalSeconds ~/ 3600)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildOptionButton(String text, EditOptions option) {
    bool isSelected = selectedOption == option;

    // Define your gradient colors here
    final gradient = isSelected
        ? const LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple
            ], // Adjust gradient colors as needed
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[300]!],
          );

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedOption = option;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(
              top: 3.0,
              bottom: 8.0,
              right: 6), // Add padding to the top and bottom
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical:
                    12), // Increase the vertical padding inside the container
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2, // Reduced border width for a finer line
                  color: isSelected ? Color(0xff706bba) : Colors.transparent,
                ),
              ),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16, // Increase the font size
                    fontWeight: FontWeight.bold,
                    // The color must be white to fully apply the gradient effect
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Depending on the selected option, show the corresponding editing widget
  Widget? _buildEditingOptions() {
    switch (selectedOption) {
      case EditOptions.font:
        if (widget.isTranslate) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Adjust the number of columns as needed
              crossAxisSpacing: 6,
              mainAxisSpacing: 4,
              childAspectRatio: 2.2, // Adjust the aspect ratio as needed
            ),
            itemCount: fonts.length,
            itemBuilder: (context, index) {
              String fontName = fonts[index];
              String textToShow = fonts[index]; // Your example text

              return GestureDetector(
                onTap: () => _onFontChanged(fontName),
                child: GridTile(
                  child: Container(
                    alignment: Alignment.center,
                    // margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedFont == fontName
                            ? Color(0xff706bba)
                            : AppColors.containerStroke,
                        width: selectedFont == fontName ? 2 : 0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      textToShow,
                      style: GoogleFonts.getFont(
                        fontName,
                        color: Colors.white,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return SizedBox
              .shrink(); // Or return any other widget you'd like to show when not translating.
        }
      case EditOptions.bgColor:
      case EditOptions.textColor:
        return SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ColorPicker(
                pickerAreaHeightPercent: 0.4,
                enableAlpha: false,
                showLabel: false,
                displayThumbColor: true,
                pickerAreaBorderRadius: BorderRadius.circular(12),
                pickerColor:
                    selectedOption == EditOptions.bgColor ? bgColor : fgColor,
                onColorChanged: _onColorChanged,
              ),
            ),
          ),
        );
      case EditOptions.editSubtitle:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const  Text('Edit Your Subtitles',style: TextStyle(color: Colors.white),),
            Expanded(
              child: ListView.builder(
                itemCount: widget.subtitles.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    color: Colors.white10,
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _controllers[index],
                            maxLines:
                                null, // Allows the input to expand as the user types
                            style: subtitleStyle.copyWith(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                widget.subtitles[index]['text'] = newValue;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Start: ${_formatTime(widget.subtitles[index]['start'].toDouble())}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  'End: ${_formatTime(widget.subtitles[index]['end'].toDouble())}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    double videoHeight = selectedOption == EditOptions.editSubtitle
        ? MediaQuery.of(context).size.height *
            0.3 // Smaller height when editing subtitles
        : MediaQuery.of(context).size.height *
            0.45; // Original height otherwise

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Video with Subtitles',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                _controller.dispose();
                List<Subtitle> editedSubtitles =
                    List.generate(_controllers.length, (index) {
                  return Subtitle(
                    start: widget.subtitles[index]['start']
                        as double, // Casting as needed
                    end: widget.subtitles[index]['end'] as double,
                    text: _controllers[index].text,
                  );
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProcessedScreen(
                        videoPath: widget.videoPath,
                        subtitles: editedSubtitles,
                        bgColor: bgColor,
                        fgColor: fgColor,
                        font: selectedFont),
                  ),
                );
              },
              child: GradientText(
                fontWeight: FontWeight.w600,
                colors: [
                  Colors.blue,
                  Colors.purple, // A lighter shade of orange
                ],
                text: 'Continue',
                fontSize: 15,

              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_controller.value.isInitialized)
            SizedBox(
              height: videoHeight,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoControlBar(
                      controller: _controller,
                      currentSubtitle: _currentSubtitle,
                      onPlayPause: () {
                        setState(() {
                          if (_isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                          _isPlaying = !_isPlaying;
                        });
                      },
                      isPlaying: _isPlaying,
                      bgColor: bgColor,
                      fgColor: fgColor,
                      textStyle: subtitleStyle,
                    ),
                  ],
                ),
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isTranslate)
                _buildOptionButton('Font', EditOptions.font),
              _buildOptionButton('BG Color', EditOptions.bgColor),
              _buildOptionButton('Text Color', EditOptions.textColor),
              _buildOptionButton('Edit Subtitle', EditOptions.editSubtitle),
            ],
          ),

          // Expanded area for the selected editing option
          Expanded(
            child: _buildEditingOptions()!,
          ),
        ],
      ),
    );
  }
}
