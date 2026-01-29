class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'] ?? json['full_name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
