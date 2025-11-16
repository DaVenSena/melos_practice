import 'package:domain/models/user.dart';

abstract class UsersRepository {
  Future<UserModel?> signIn(String username, String password);
  Future<UserModel?> signUp(String username, String password);
  Future<bool> updateUser(UserModel user);
  Future<bool> deleteUser(String id);
}
