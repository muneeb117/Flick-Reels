import 'package:flick_reels/screens/voice_over/widgets/selectableAvatar.dart';
import 'package:flick_reels/screens/voice_over/widgets/voice_data.dart';
import 'package:flutter/material.dart';

class AllAvatarsPage extends StatefulWidget {
  final String? initialSelectedVoiceId;
  final Function(String voiceId, Color backgroundColor) onSelectAvatar;

  AllAvatarsPage({required this.onSelectAvatar, this.initialSelectedVoiceId});

  @override
  _AllAvatarsPageState createState() => _AllAvatarsPageState();
}

class _AllAvatarsPageState extends State<AllAvatarsPage> {
  String? _selectedVoiceId;

  @override
  void initState() {
    super.initState();
    _selectedVoiceId = widget.initialSelectedVoiceId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an Avatar'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: voices.length,
        itemBuilder: (context, index) {
          final voice = voices[index];
          return SelectableAvatar(
            imageProvider: voice.avatarImage,
            isSelected: _selectedVoiceId == voice.voiceId,
            onTap: () {
              setState(() {
                _selectedVoiceId = voice.voiceId;
              });
              widget.onSelectAvatar(voice.voiceId, voice.backgroundColor);
              Navigator.pop(context);
            },
            backgroundColor: voice.backgroundColor,
          );
        },
      ),
    );
  }
}
