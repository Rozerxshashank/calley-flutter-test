class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String subscription;
  final String parentAccount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone = '+91 7678286227',
    this.subscription = 'Calley Personal',
    this.parentAccount = 'NA',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '68626f9497757cb741f449b0',
      username: json['username'] ?? 'Swati',
      email: json['email'] ?? 'swati@calley.in',
      phone: json['phone'] ?? '+91 7678286227',
      subscription: json['subscription'] ?? 'Calley Personal',
      parentAccount: json['parentAccount'] ?? 'NA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'subscription': subscription,
      'parentAccount': parentAccount,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? subscription,
    String? parentAccount,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subscription: subscription ?? this.subscription,
      parentAccount: parentAccount ?? this.parentAccount,
    );
  }
}

