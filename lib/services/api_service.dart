import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/api_constanst.dart';

class ScriptGeneratorApi {
  ScriptGeneratorApi();

  Future<String> generateScript(String topic) async {
    String prompt = generatePrompt(topic);
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
        print('Failed to generate script: StatusCode=${response.statusCode}, Body=${response.body}');
        return 'Error: Failed to generate script. StatusCode=${response.statusCode}';
      }
    } catch (e) {
      print('Exception caught: $e');
      return 'Error: Exception caught during script generation.';
    }
  }

  String generatePrompt(String topic) {
    return "Create a script for a short video introducing the topic '${topic}', starting with a greeting and then explaining the topic in an engaging way.";
  }
}
