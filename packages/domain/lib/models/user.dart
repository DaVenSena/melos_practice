import 'package:data/entities/user.dart';

class UserModel {
  final int? id;
  final String name;
  final String password;

  UserModel({this.id, required this.name, required this.password});

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      password: entity.password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, password: password);
  }
}
