abstract class ScriptState {}

class ScriptInitial extends ScriptState {}

class ScriptLoading extends ScriptState {}

class ScriptLoaded extends ScriptState {
  final String script;
  ScriptLoaded(this.script);
}

class ScriptError extends ScriptState {
  final String message;
  ScriptError(this.message);
}

class TopicNotEmptyState extends ScriptState {
  final bool isNotEmpty;
  TopicNotEmptyState(this.isNotEmpty);
}
class ScriptNotEmptyState extends ScriptState {
  final String scriptText;

  ScriptNotEmptyState(this.scriptText);
}
