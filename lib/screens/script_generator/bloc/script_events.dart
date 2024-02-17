abstract class ScriptEvent {}

class GenerateScriptEvent extends ScriptEvent {
  final String topic;
  GenerateScriptEvent(this.topic);
}

class UserEditsScriptEvent extends ScriptEvent {
  final String scriptText;
  UserEditsScriptEvent(this.scriptText);
}

class TopicChangedEvent extends ScriptEvent {
  final bool isNotEmpty;
  TopicChangedEvent(this.isNotEmpty);
}
class ScriptTextChangedEvent extends ScriptEvent {
  final String scriptText;

  ScriptTextChangedEvent(this.scriptText);
}
