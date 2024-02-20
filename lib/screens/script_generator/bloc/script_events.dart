abstract class ScriptGenerationEvent {}

class GenerateScriptEvent extends ScriptGenerationEvent {
  final String topic;
  final String keyPoints;
  final String tone;

  GenerateScriptEvent({required this.topic, required this.keyPoints, required this.tone});
}
