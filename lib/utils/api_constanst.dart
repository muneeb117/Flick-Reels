
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
 static String apiKey = dotenv.env['OPENAI_API_KEY']!;
  static String apiUrl = 'https://api.openai.com/v1/completions';
}