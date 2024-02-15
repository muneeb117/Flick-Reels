import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_events.dart';
import 'package:flick_reels/screens/authentication/sign_in/bloc/sign_in_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Inside your sign_in_bloc.dart
class SignInBloc extends Bloc<SignInEvents, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<EmailEvents>(_emailEvent);
    on<PasswordEvents>(_passwordEvent);
    on<SignInResetEvent>(_resetEvent); // Add handler for reset event
  }

  void _emailEvent(EmailEvents event, Emitter<SignInState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordEvents event, Emitter<SignInState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _resetEvent(SignInResetEvent event, Emitter<SignInState> emit) {
    emit(const SignInState()); // Reset state to initial values
  }
}
