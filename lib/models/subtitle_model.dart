class Subtitle {
  final double start;
  final double end;
  final String text;

  Subtitle({required this.start, required this.end, required this.text});

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'text': text,
    };
  }
}
