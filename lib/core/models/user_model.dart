class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? adminId;
  String? companyName;
  bool allowGoogleLogin;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.adminId,
    this.companyName,
    required this.allowGoogleLogin,
  });

  bool get isAdmin => role?.trim().toLowerCase() == 'admin';
  bool get isFinance => role?.trim().toLowerCase() == 'finance';
  bool get isWarehouse => role?.trim().toLowerCase() == 'warehouse';

  /// Resolves the effective tenant ID. For admin, it's their own UID.
  String get effectiveAdminId => (adminId != null && adminId!.isNotEmpty)
      ? adminId!
      : (isAdmin ? (uid ?? '') : '');

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"] ?? '',
    email: json["email"] ?? '',
    firstName: json["first_name"] ?? '',
    lastName: json["last_name"] ?? '',
    role: json["role"] ?? '',
    adminId: json["admin_id"] ?? '',
    companyName: json["company_name"] ?? '',
    allowGoogleLogin: json["allow_google_login"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "role": role,
    "admin_id": adminId,
    "company_name": companyName,
    "allow_google_login": allowGoogleLogin,
  };
}
