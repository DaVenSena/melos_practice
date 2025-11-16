import 'package:domain/models/user.dart';
import 'package:domain/repositories/users/users_repo.dart';

abstract class SignUpUsecase {
  Future<UserModel?> call(String username, String password);
}

class SignUpUsecaseImpl implements SignUpUsecase {
  final UsersRepository usersRepository;

  SignUpUsecaseImpl({required this.usersRepository});

  @override
  Future<UserModel?> call(String username, String password) async {
    return await usersRepository.signUp(username, password);
  }
}
