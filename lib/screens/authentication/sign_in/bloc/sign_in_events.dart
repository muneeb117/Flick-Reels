// Inside your sign_in_events.dart
abstract class SignInEvents {
  const SignInEvents();
}

class EmailEvents extends SignInEvents {
  final String email;
  EmailEvents(this.email);
}

class PasswordEvents extends SignInEvents {
  final String password;
  PasswordEvents(this.password);
}

class SignInResetEvent extends SignInEvents {
  // This event will reset the state to its initial values
}
