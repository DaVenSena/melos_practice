import 'package:domain/models/user.dart';
import 'package:domain/repositories/users/users_repo.dart';

abstract class SignInUsecase {
  Future<UserModel?> call(String username, String password);
}

class SignInUsecaseImpl implements SignInUsecase {
  final UsersRepository usersRepository;

  SignInUsecaseImpl({required this.usersRepository});

  @override
  Future<UserModel?> call(String username, String password) async {
    return await usersRepository.signIn(username, password);
  }
}
