import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/api_service.dart';
import 'script_events.dart';
import 'script_states.dart';

class ScriptBloc extends Bloc<ScriptEvent, ScriptState> {
  final ScriptGeneratorApi api=ScriptGeneratorApi();

  ScriptBloc() : super(ScriptInitial()) {
    on<GenerateScriptEvent>(_onGenerateScriptEvent);
    on<UserEditsScriptEvent>(_onUserEditsScriptEvent);
    on<TopicChangedEvent>(_onTopicChangedEvent);
    on<ScriptTextChangedEvent>(_onScriptChangedEvent);
  }

  Future<void> _onGenerateScriptEvent(GenerateScriptEvent event, Emitter<ScriptState> emit) async {
    emit(ScriptLoading());
    try {
      final script = await api.generateScript(event.topic);
      emit(ScriptLoaded(script));
    } catch (error) {
      emit(ScriptError(error.toString()));
    }
  }

  void _onUserEditsScriptEvent(UserEditsScriptEvent event, Emitter<ScriptState> emit) {
    emit(ScriptLoaded(event.scriptText)); // Consider creating a separate state if needed
  }

  void _onTopicChangedEvent(TopicChangedEvent event, Emitter<ScriptState> emit) {
    emit(TopicNotEmptyState(event.isNotEmpty));
  }
  void _onScriptChangedEvent(ScriptTextChangedEvent event, Emitter<ScriptState> emit) {
    if (event.scriptText.isNotEmpty) {
      emit(ScriptNotEmptyState(event.scriptText));
    } else {
      emit(ScriptInitial());
    }
  }

}
