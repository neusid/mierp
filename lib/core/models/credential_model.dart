class Credential {
  String? email;
  bool isSave;

  Credential({
    required this.email,
    required this.isSave,
  });

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    email: json["email"]??null,
    isSave: json["isSave"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "isSave": isSave,
  };
}
