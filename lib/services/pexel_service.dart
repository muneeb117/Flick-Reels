import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsService {
  final String apiKey = 'G7i20ttVgUkCBvcPj19gubGlOvKaScdT9wkoK4pf83qOavl9RUWkoMJ9';

  Future<List<VideoTemplate>> searchVideos(String query) async {
    final url = Uri.parse('https://api.pexels.com/videos/search?query=$query&per_page=12');
    final response = await http.get(url, headers: {'Authorization': apiKey});

    if (response.statusCode == 200) {
      final List videos = json.decode(response.body)['videos'];
      return videos.map((video) => VideoTemplate.fromJson(video)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}

class VideoTemplate {
  final int id;
  final String videoUrl;
  final String thumbnailUrl;

  VideoTemplate({required this.id, required this.videoUrl, required this.thumbnailUrl});

  factory VideoTemplate.fromJson(Map<String, dynamic> json) {
    final videoFile = json['video_files'].firstWhere((file) => file['quality'] == 'hd');
    return VideoTemplate(
      id: json['id'],
      videoUrl: videoFile['link'],
      thumbnailUrl: json['image'],
    );
  }

}
