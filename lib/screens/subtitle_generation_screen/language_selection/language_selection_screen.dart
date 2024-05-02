import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/gradient_text.dart';
import '../../../utils/colors.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String initialLanguageCode;
  final bool initialIsTranslate;
  final Function(String languageCode, String taskType) onLanguageSelected;

  LanguageSelectionScreen({
    super.key,
    required this.onLanguageSelected,
    required this.initialLanguageCode,
    this.initialIsTranslate = true,
  });

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLanguageCode = 'en';
  bool _isTranslate = true;
  List<String> _languageCodes = [];
  final Map<String, String> _languagesMap = {
    'af': 'Afrikaans',
    'sq': 'Albanian',
    'am': 'Amharic',
    'ar': 'Arabic',
    'hy': 'Armenian',
    'az': 'Azerbaijani',
    'eu': 'Basque',
    'be': 'Belarusian',
    'bn': 'Bengali',
    'bs': 'Bosnian',
    'bg': 'Bulgarian',
    'ca': 'Catalan',
    'ceb': 'Cebuano',
    'ny': 'Chichewa',
    'zh': 'Chinese (Simplified)',
    'zh-TW': 'Chinese (Traditional)',
    'co': 'Corsican',
    'hr': 'Croatian',
    'cs': 'Czech',
    'da': 'Danish',
    'nl': 'Dutch',
    'en': 'English',
    'eo': 'Esperanto',
    'et': 'Estonian',
    'tl': 'Filipino',
    'fi': 'Finnish',
    'fr': 'French',
    'fy': 'Frisian',
    'gl': 'Galician',
    'ka': 'Georgian',
    'de': 'German',
    'el': 'Greek',
    'gu': 'Gujarati',
    'ht': 'Haitian Creole',
    'ha': 'Hausa',
    'haw': 'Hawaiian',
    'iw': 'Hebrew',
    'he': 'Hebrew', // modern code for Hebrew
    'hi': 'Hindi',
    'hmn': 'Hmong',
    'hu': 'Hungarian',
    'is': 'Icelandic',
    'ig': 'Igbo',
    'id': 'Indonesian',
    'ga': 'Irish',
    'it': 'Italian',
    'ja': 'Japanese',
    'jw': 'Javanese',
    'kn': 'Kannada',
    'kk': 'Kazakh',
    'km': 'Khmer',
    'rw': 'Kinyarwanda',
    'ko': 'Korean',
    'ku': 'Kurdish (Kurmanji)',
    'ky': 'Kyrgyz',
    'lo': 'Lao',
    'la': 'Latin',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'lb': 'Luxembourgish',
    'mk': 'Macedonian',
    'mg': 'Malagasy',
    'ms': 'Malay',
    'ml': 'Malayalam',
    'mt': 'Maltese',
    'mi': 'Maori',
    'mr': 'Marathi',
    'mn': 'Mongolian',
    'my': 'Myanmar (Burmese)',
    'ne': 'Nepali',
    'no': 'Norwegian',
    'or': 'Odia (Oriya)',
    'ps': 'Pashto',
    'fa': 'Persian',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'pa': 'Punjabi',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sm': 'Samoan',
    'gd': 'Scots Gaelic',
    'sr': 'Serbian',
    'st': 'Sesotho',
    'sn': 'Shona',
    'sd': 'Sindhi',
    'si': 'Sinhala',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'so': 'Somali',
    'es': 'Spanish',
    'su': 'Sundanese',
    'sw': 'Swahili',
    'sv': 'Swedish',
    'tg': 'Tajik',
    'ta': 'Tamil',
    'tt': 'Tatar',
    'te': 'Telugu',
    'th': 'Thai',
    'tr': 'Turkish',
    'tk': 'Turkmen',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'ug': 'Uyghur',
    'uz': 'Uzbek',
    'vi': 'Vietnamese',
    'cy': 'Welsh',
    'xh': 'Xhosa',
    'yi': 'Yiddish',
    'yo': 'Yoruba',
    'zu': 'Zulu'
  };

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.initialLanguageCode;
    _isTranslate = widget.initialIsTranslate;

    _languageCodes = _languagesMap.keys.toList();
  }
  void _filterLanguages(String searchTerm) {
    List<String> filteredLanguages;
    if (searchTerm.isEmpty) {
      filteredLanguages = _languagesMap.keys.toList();
    } else {
      filteredLanguages = _languageCodes
          .where((code) => _languagesMap[code]!
          .toLowerCase()
          .contains(searchTerm.toLowerCase()))
          .toList();
    }

    filteredLanguages.remove(_selectedLanguageCode);
    setState(() {
      filteredLanguages.insert(0, _selectedLanguageCode);
      _languageCodes = filteredLanguages;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Select Language',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                final taskType = _isTranslate ? 'translate' : 'transcribe';
                Navigator.pop(context, {
                  'languageCode': _selectedLanguageCode,
                  'taskType': taskType,
                  'isTranslate': _isTranslate,
                });
              },
              child: GradientText(
                colors: [Colors.purple, Colors.blue],
                text: 'Done',
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Color(0xff262626),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white54),
            ),
            child: TextFormField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.only(top: 25.h),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryBackground,
                  size: 23,
                ),
              ),
              onChanged: _filterLanguages,
            ),
          ),
          SwitchListTile(
            hoverColor:Colors.transparent,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white10,
            activeTrackColor: Color(0xff706bba),
            activeColor: Colors.white,
            title: GradientText(
              colors:_isTranslate?[Colors.purple,Colors.blue]:[Colors.grey,Colors.grey],
              text:_isTranslate? 'Caption Generated in English':'Translate to English for Accuracy',
              fontSize: 16,
            ),
            value: _isTranslate,
            onChanged: (bool value) {
              setState(() {
                _isTranslate = value;
                _selectedLanguageCode = 'en';
              });
            },
          ),
          if (!_isTranslate) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: GradientText(
                    colors: [Colors.purple, Colors.blue],
                    text: 'Transcribe To',
                    fontSize: 16,
                  )),
            ),
          ],
          Expanded(
            child: ListView.separated(
              itemCount: _languageCodes.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white12,
                height: 5,
                indent: 80,
                endIndent: 25,
              ),
              itemBuilder: (context, index) {
                final code = _languageCodes[index];
                final languageName = _languagesMap[code]!;
                return ListTile(
                  splashColor: Colors.transparent,
                  title: Text(
                    languageName,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  leading: Radio<String>(
                    activeColor: Color(0xff706bba), // Your desired active color
                    value: code,
                    groupValue: _selectedLanguageCode,
                    onChanged: !_isTranslate
                        ? (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedLanguageCode = value;
                              });
                            }
                          }
                        : null,
                  ),
                  onTap: !_isTranslate
                      ? () {
                          setState(() {
                            _selectedLanguageCode = code;
                          });
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}