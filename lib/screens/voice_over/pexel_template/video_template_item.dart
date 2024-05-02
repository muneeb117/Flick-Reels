import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/colors.dart';


class VideoTemplateItem extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final bool isSelected;
  final Function(bool) onSelect;
  final Function(int) onPlay; // Callback to handle video play centrally
  final int templateId; // Unique identifier for each template

  VideoTemplateItem({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.isSelected,
    required this.onSelect,
    required this.onPlay,
    required this.templateId,
  });

  @override
  _VideoTemplateItemState createState() => _VideoTemplateItemState();
}

class _VideoTemplateItemState extends State<VideoTemplateItem> {
  VideoPlayerController? _controller;
  bool _isBuffering = false;

  void _initializePlayer() async {
    if (_controller == null) {
      setState(() {
        _isBuffering =
            true; // Only set buffering when initialization is triggered
      });
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          setState(() {
            _isBuffering = false;
          });
          _controller!.setLooping(true);
          if (widget.isSelected) {
            widget.onPlay(widget.templateId);
            _controller!.play();
          }
        });
      _controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelect(!widget.isSelected);
        if (_controller == null || !_controller!.value.isInitialized) {
          _initializePlayer();
        }
        if (widget.isSelected && !_controller!.value.isPlaying) {
          widget.onPlay(widget.templateId);
          _controller?.play();
        } else {
          _controller?.pause();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: widget.isSelected
                  ? Border.all(color: AppColors.primaryBackground, width: 3)
                  : null,
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: _controller != null && _controller!.value.isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        Image.network(widget.thumbnailUrl, fit: BoxFit.cover)),
          ),
          if (_isBuffering) // Only show the CircularProgressIndicator when buffering
            CircularProgressIndicator(),
          IconButton(
            icon: Icon(
              _controller != null && _controller!.value.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 33.0,
              color: Colors.white,
            ),
            onPressed: () {
              if (_controller == null) {
                _initializePlayer();
              } else if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                widget.onPlay(widget.templateId);
                _controller!.play();
              }
            },
          ),
          if (widget.isSelected)
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(Icons.check_circle, size: 20.0, color: Colors.green,),
            ),
        ],
      ),
    );
  }
}
