import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/api_constanst.dart';

class ScriptGeneratorApi {
  ScriptGeneratorApi();

  // Add parameters for keyPoints and tone
  Future<String> generateScript(String topic, String  keyPoints, String tone) async {
    String prompt = generatePrompt(topic, keyPoints, tone);
    try {
      var response = await http.post(
        Uri.parse(ApiConstants.apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConstants.apiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo-instruct',
          'prompt': prompt,
          'max_tokens': 500,
          'temperature': 0.7,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String text = data['choices'][0]['text'];
        return text.trim();
      } else {
        print(
            'Failed to generate script: StatusCode=${response.statusCode}, Body=${response.body}');
        return 'Error: Failed to generate script. StatusCode=${response.statusCode}';
      }
    } catch (e) {
      print('Exception caught: $e');
      return 'Error: Exception caught during script generation.';
    }
  }

  // Modify this method to include key points and tone
  String generatePrompt(String topic, String keyPoints, String tone) {

    return "Create a script for a short video on the topic '${topic}'. The script should start with a greeting and then explain the topic in an engaging way. Please include the following key points:\n$keyPoints\nThe tone of the script should be $tone.";
  }
}
