import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(id: user.id, name: user.name, email: user.email);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] as String?;
    final name = json['name'] as String?;
    final email = json['email'] as String?;
    
    if (id == null || name == null || email == null) {
      throw Exception('Invalid response format: required fields are missing');
    }
    
    return UserModel(
      id: id,
      name: name,
      email: email,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}
