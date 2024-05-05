import 'dart:convert';
import 'package:http/http.dart' as http;


class VoiceOverScript {
  // ScriptGeneratorApi();

  // Add parameters for keyPoints and tone
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
          'max_tokens': 200,
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
  String generatePrompt(String topic) {

    return "Provide an informative and engaging explanation about the topic '${topic}'. Avoid any video or camera instructions, just focus on the subject matter itself.";
  }
}


class ApiConstants {
  static String apiKey = "sk-proj-m068FOwTwz3F711BLm3AT3BlbkFJtwVBqG3RTNPjOKzVfc67";
  static String apiUrl = 'https://api.openai.com/v1/completions';
}