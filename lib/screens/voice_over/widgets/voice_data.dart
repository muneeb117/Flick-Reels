import 'package:flutter/material.dart';

class VoiceData {
  final String voiceId;
  final String name;
  final ImageProvider avatarImage;
  final Color backgroundColor;

  VoiceData({
    required this.voiceId,
    required this.name,
    required this.avatarImage,
    required this.backgroundColor,
  });
}

List<VoiceData> voices = [
  // Female Voices



  // Male Voices
  VoiceData(
    voiceId: 'en-AU-Standard-B',
    name: 'George',
    avatarImage: AssetImage('assets/voice_images/male1.png'),
    backgroundColor: Colors.grey.shade300,
  ),
  VoiceData(
    voiceId: 'en-AU-Standard-D',
    name: 'Henry',
    avatarImage: AssetImage('assets/voice_images/male2.png'),
    backgroundColor: Colors.yellow.shade100,
  ),
  VoiceData(
    voiceId: 'en-IN-Standard-B',
    name: 'Ian',
    avatarImage: AssetImage('assets/voice_images/male3.png'),
    backgroundColor: Colors.blueGrey.shade100,
  ),
  VoiceData(
    voiceId: 'en-AU-Standard-A',
    name: 'Amelia',
    avatarImage: AssetImage('assets/voice_images/female1.png'),
    backgroundColor: Colors.pink.shade100,
  ),

  VoiceData(
    voiceId: 'en-IN-Standard-C',
    name: 'Jack',
    avatarImage: AssetImage('assets/voice_images/male4.png'),
    backgroundColor: Colors.teal.shade100,
  ),
  VoiceData(
    voiceId: 'en-GB-Standard-B',
    name: 'Kyle',
    avatarImage: AssetImage('assets/voice_images/male5.png'),
    backgroundColor: Colors.brown.shade100,
  ),
  VoiceData(
    voiceId: 'en-GB-Standard-D',
    name: 'Leo',
    avatarImage: AssetImage('assets/voice_images/male6.png'),
    backgroundColor: Colors.lime.shade100,
  ),
  VoiceData(
    voiceId: 'en-US-Standard-B',
    name: 'Max',
    avatarImage: AssetImage('assets/voice_images/male7.png'),
    backgroundColor: Colors.deepPurple.shade100,
  ),
  VoiceData(
    voiceId: 'pa-IN-Standard-C',
    name: 'Gurjeet',
    avatarImage: AssetImage('assets/voice_images/female6.png'),
    backgroundColor: Colors.red.shade100,
  ),
  VoiceData(
    voiceId: 'en-US-Standard-D',
    name: 'Nathan',
    avatarImage: AssetImage('assets/voice_images/male8.png'),
    backgroundColor: Colors.cyan.shade100,
  ),
  VoiceData(
    voiceId: 'en-AU-Standard-C',
    name: 'Bella',
    avatarImage: AssetImage('assets/voice_images/female2.png'),
    backgroundColor: Colors.purple.shade200,
  ),
  VoiceData(
    voiceId: 'en-US-Standard-I',
    name: 'Oliver',
    avatarImage: AssetImage('assets/voice_images/male9.png'),
    backgroundColor: Colors.amber.shade100,
  ),
  VoiceData(
    voiceId: 'en-GB-Standard-C',
    name: 'Eva',
    avatarImage: AssetImage('assets/voice_images/female5.png'),
    backgroundColor: Colors.green.shade100,
  ),

  VoiceData(
    voiceId: 'en-US-Standard-J',
    name: 'Patrick',
    avatarImage: AssetImage('assets/voice_images/male10.png'),
    backgroundColor: Colors.deepOrange.shade100,
  ),
  VoiceData(
    voiceId: 'en-US-Wavenet-M',
    name: 'Quentin',
    avatarImage: AssetImage('assets/voice_images/male11.png'),
    backgroundColor: Colors.brown.shade100,
  ),

  VoiceData(
    voiceId: 'en-GB-Standard-A',
    name: 'Daisy',
    avatarImage: AssetImage('assets/voice_images/female4.png'),
    backgroundColor: Colors.blue.shade100,
  ),

  VoiceData(
    voiceId: 'ar-XA-Standard-B',
    name: 'Ryan',
    avatarImage: AssetImage('assets/voice_images/male12.png'),
    backgroundColor: Colors.blue.shade200,
  ),
  VoiceData(
    voiceId: 'pa-IN-Standard-B',
    name: 'Steven',
    avatarImage: AssetImage('assets/voice_images/male13.png'),
    backgroundColor: Colors.red.shade100,
  ),
  VoiceData(
    voiceId: 'pa-IN-Standard-D',
    name: 'Gurdeep Singh',
    avatarImage: AssetImage('assets/voice_images/male14.png'),
    backgroundColor: Colors.indigo.shade200,
  ),
  VoiceData(
    voiceId: 'en-IN-Standard-A',
    name: 'Charlotte',
    avatarImage: AssetImage('assets/voice_images/female3.png'),
    backgroundColor: Colors.orange.shade100,
  ),
];
