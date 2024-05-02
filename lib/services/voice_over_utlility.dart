import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class VoiceOverUtility {
  final String apiKey;
  AudioPlayer audioPlayer;

  VoiceOverUtility({required this.apiKey, required this.audioPlayer});

  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  Future<String?> convertTextToSpeech(String text, String voiceName) async {
    final client = clientViaApiKey(apiKey);
    final ttsApi = TexttospeechApi(client);
    String languageCode = voiceName.split('-').sublist(0, 2).join('-');

    final request = SynthesizeSpeechRequest()
      ..input = (SynthesisInput()..text = text)
      ..voice = (VoiceSelectionParams()
        ..languageCode = languageCode
        ..name = voiceName
        ..ssmlGender = 'NEUTRAL')
      ..audioConfig = (AudioConfig()..audioEncoding = 'MP3');

    final response = await ttsApi.text.synthesize(request);
    client.close();

    if (response.audioContent == null) return null;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final audioBytes = base64Decode(response.audioContent!);
    final audioFile = await getOutputPath('voiceover_audio_$timestamp.mp3');
    await File(audioFile).writeAsBytes(audioBytes);

    return audioFile;
  }



  Future<String> mergeAudioAndVideo(String audioPath, String videoPath) async {
    // Obtain the directory for storing the output file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputVideoPath = '${directory.path}/voiceover_video_$timestamp.mp4';

    // Construct the FFmpeg command to merge audio and video
    final String command = '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -strict experimental -map 0:v -map 1:a "$outputVideoPath"';

    // Execute the FFmpeg command using FFmpegKit
    final session = await FFmpegKit.execute(command);

    // Optionally check the return status or log output
    session.getReturnCode().then((returnCode) {
      if (returnCode!.isValueSuccess()) {
        print("Video merged successfully!");
      } else {
        print("Error occurred during video merging: ${returnCode.getValue()}");
      }
    });

    // Return the path of the merged video file
    return outputVideoPath;
  }

  Future<String> getOutputPath(String fileName) async {
    final extDir = await getExternalStorageDirectory();
    final dirPath = '${extDir!.path}/Movies/VoiceOverApp';
    await Directory(dirPath).create(recursive: true);
    return '$dirPath/$fileName';
  }
}
