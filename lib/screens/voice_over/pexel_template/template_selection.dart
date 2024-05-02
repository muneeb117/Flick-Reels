import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flick_reels/screens/voice_over/pexel_template/video_template_item.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../../components/reusable_button.dart';
import '../../../services/pexel_service.dart';
import '../../../utils/colors.dart';
import '../widgets/upload_button.dart';

class TemplateSelection extends StatefulWidget {
  final Function(String path) onVideoSelected;
  const TemplateSelection({Key? key, required this.onVideoSelected})
      : super(key: key);

  @override
  _TemplateSelectionState createState() => _TemplateSelectionState();
}

class _TemplateSelectionState extends State<TemplateSelection> {
  final PexelsService _pexelsService = PexelsService();
  List<VideoTemplate> _templates = [];
  Set<int> _selectedTemplateIds = Set<int>();
  String _searchQuery = 'videos';
  bool _isLoading = false;

  int? _playingVideoId;

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    _searchTemplates('nature');
  }

  void _searchTemplates(String query) async {
    try {
      final templates =
          await _pexelsService.searchVideos(query.isEmpty ? 'default' : query);
      setState(() {
        _templates = templates;
      });
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

  void _onSelect(int id, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (_selectedTemplateIds.length < 3) {
          _selectedTemplateIds.add(id);
        }
      } else {
        _selectedTemplateIds.remove(id);
      }
    });
  }

  void _handleVideoUpload() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      widget.onVideoSelected(result.files.single.path!);
      Navigator.pop(context);
    }
  }

  Future<void> _processSelection() async {
    if (_selectedTemplateIds.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    var directory = await getApplicationDocumentsDirectory();
    var filePaths = <String>[];

    for (var id in _selectedTemplateIds) {
      var template = _templates.firstWhere((t) => t.id == id);
      var response = await http.get(Uri.parse(template.videoUrl));
      if (response.statusCode == 200) {
        var videoPath = '${directory.path}/${template.id}.mp4';
        await File(videoPath).writeAsBytes(response.bodyBytes);
        filePaths.add(videoPath);
      }
    }

    String finalVideoPath;

    if (filePaths.length > 1) {
      var fileList = filePaths.map((path) => "file '$path'").join('\n');
      var tempFile = File('${directory.path}/filelist.txt');
      await tempFile.writeAsString(fileList);

      finalVideoPath = '${directory.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await FFmpegKit.execute('-f concat -safe 0 -i ${tempFile.path} -c copy $finalVideoPath');
    } else {
      finalVideoPath = filePaths.first;
    }

    setState(() {
      _isLoading = false;
    });

    widget.onVideoSelected(finalVideoPath);
    Navigator.pop(context);
  }

  void _handleVideoPlay(int id) {
    if (_playingVideoId != null && _playingVideoId != id) {
      _templates.forEach((template) {
        if (template.id == _playingVideoId) {
          _handleVideoPlay(_playingVideoId!);
        }
      });
    }
    setState(() {
      _playingVideoId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: const Text(
            'Templates',
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                margin: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.strokeColor),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _searchTemplates(_searchQuery);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search for templates',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                    filled: true, // Add this line for a fill color
                    fillColor: Colors.white, // Choose an appropriate fill color
                  ),
                ),
              ),
              SizedBox(height: 5.h,),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _templates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (1 / 0.6),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return VideoTemplateItem(
                      videoUrl: template.videoUrl,
                      thumbnailUrl: template.thumbnailUrl,
                      isSelected: _selectedTemplateIds.contains(template.id),
                      onSelect: (isSelected) =>
                          _onSelect(template.id, isSelected),
                      onPlay: _handleVideoPlay,
                      templateId: template.id,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              if (_selectedTemplateIds.isEmpty)
                UploadButton(onPressed: _handleVideoUpload),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ReusableButton(
                  text: 'Continue with Selected Template',
                  onPressed: _processSelection,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
          _isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
