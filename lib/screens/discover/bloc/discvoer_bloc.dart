import 'package:flick_reels/screens/discover/bloc/discover_events.dart';
import 'package:flick_reels/screens/discover/bloc/discover_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverBloc extends Bloc<DiscoverEvents, DiscoverStates> {
  DiscoverBloc() : super(DiscoverStates()) {
    on<DiscoverEvents>((event, emit) {
      emit(DiscoverStates(page: state.page));
    });
  }
}
