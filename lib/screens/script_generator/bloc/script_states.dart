abstract class ScriptGenerationState {}

class ScriptGenerationInitial extends ScriptGenerationState {}

class ScriptGenerationLoading extends ScriptGenerationState {}

class ScriptGenerationLoaded extends ScriptGenerationState {
  final String script;

  ScriptGenerationLoaded(this.script);
}

class ScriptGenerationError extends ScriptGenerationState {
  final String error; // Ensure this field is defined

  ScriptGenerationError(this.error); // Ensure this constructor is correct
}
