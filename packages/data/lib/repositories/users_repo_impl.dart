import 'package:data/data_source/base_data_source.dart';
import 'package:domain/models/user.dart';
import 'package:domain/repositories/users/users_repo.dart';

class UsersRepoImpl implements UsersRepository {
  final BaseDataSource dataSource;

  UsersRepoImpl({required this.dataSource});

  @override
  Future<UserModel?> signUp(String username, String password) async {
    final user = await dataSource.signUp(username, password);
    if (user == null) return null;
    return UserModel.fromEntity(user);
  }

  @override
  Future<bool> deleteUser(String id) async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> signIn(String username, String password) async {
    final user = await dataSource.signIn(username);
    if (user == null || user.password != password) return null;
    return UserModel.fromEntity(user);
  }

  @override
  Future<bool> updateUser(UserModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
