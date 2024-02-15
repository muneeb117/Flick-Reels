class RegisterState {
  String email;
  String name;
  String password;
  String rePassword;
  String imageUrl; // New field for image URL

  RegisterState({
    this.email = "",
    this.name = "",
    this.password = "",
    this.rePassword = "",
    this.imageUrl = "", // Initialize with an empty string
  });

  RegisterState copyWith({
    String? email,
    String? name,
    String? password,
    String? rePassword,
    String? imageUrl, // Add imageUrl parameter
  }) {
    return RegisterState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      imageUrl: imageUrl ?? this.imageUrl, // Assign imageUrl
    );
  }
}
