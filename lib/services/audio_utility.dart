import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class AudioUtility {
  static Future<String?> uploadVideoAndGetEnhancedAudio(File videoFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://172.20.4.226:5001/uploadVideo'));
    request.files.add(await http.MultipartFile.fromPath('file', videoFile.path));
    var streamedResponse = await request.send();
    print(streamedResponse);
    var response = await http.Response.fromStream(streamedResponse);
    print(response);

    if (response.statusCode == 200) {
      print(response.body);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File enhancedAudioFile = File('$tempPath/enhancedAudio.mp3');
      await enhancedAudioFile.writeAsBytes(response.bodyBytes);
      return enhancedAudioFile.path;
    }
    return null;
  }

  static Future<String> mergeAudioAndVideo(String audioPath, String videoPath) async {
    final outputDirectory = await getApplicationDocumentsDirectory();
    final outputPath = '${outputDirectory.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final command = '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -strict experimental -map 0:v -map 1:a "$outputPath"';
    await FFmpegKit.execute(command);
    return outputPath;
  }
}
