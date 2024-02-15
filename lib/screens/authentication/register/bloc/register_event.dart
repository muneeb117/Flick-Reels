abstract class RegisterEvent{
  const RegisterEvent();
}
class EmailEvent extends RegisterEvent{
  final String email;
  EmailEvent(this.email);
}
class NameEvent extends RegisterEvent{
  final String name;
  NameEvent(this.name);

}
class PasswordEvent extends RegisterEvent{
  final String password;
  PasswordEvent(this.password);
}
class RePasswordEvent extends RegisterEvent{
  final String rePassword;
  RePasswordEvent(this.rePassword);
}
class ImageUrlEvent extends RegisterEvent {
  final String imageUrl;
  ImageUrlEvent(this.imageUrl);
}
