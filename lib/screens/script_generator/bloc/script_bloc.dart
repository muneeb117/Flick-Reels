import 'package:flick_reels/screens/script_generator/bloc/script_events.dart';
import 'package:flick_reels/screens/script_generator/bloc/script_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';

class ScriptGenerationBloc extends Bloc<ScriptGenerationEvent, ScriptGenerationState> {
  final ScriptGeneratorApi scriptGeneratorApi=ScriptGeneratorApi();

  ScriptGenerationBloc() : super(ScriptGenerationInitial()) {
    on<GenerateScriptEvent>((event, emit) async {
      emit(ScriptGenerationLoading());
      try {
        final script = await scriptGeneratorApi.generateScript(event.topic, event.keyPoints, event.tone);
        emit(ScriptGenerationLoaded(script));
      } catch (error) {
        emit(ScriptGenerationError('Failed to generate script'));
      }
    });
  }
}
