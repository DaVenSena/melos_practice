class UserEntity {
  final int? id;
  final String name;
  final String password;

  UserEntity({this.id, required this.name, required this.password});

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'password': password};
  }
}
