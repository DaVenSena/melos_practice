import 'package:domain/models/user.dart';
import 'package:domain/repositories/users/user_repo_provider.dart';
import 'package:features_todo_app/use_cases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/app/app_prefs.dart';

final signInUsecaseProvider = Provider<SignInUsecase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return SignInUsecaseImpl(usersRepository: repository);
});

final signUpUsecaseProvider = Provider<SignUpUsecase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return SignUpUsecaseImpl(usersRepository: repository);
});

class UserNotifier extends AsyncNotifier<UserModel> {
  SignInUsecase get _signInUsecase => ref.read(signInUsecaseProvider);
  SignUpUsecase get _signUpUsecase => ref.read(signUpUsecaseProvider);
  AppPrefs get _appPrefs => ref.read(appPrefsProvider);

  @override
  Future<UserModel> build() async {
    try {
      return await _appPrefs.getUser() ?? UserModel(name: '', password: '');
    } catch (e) {
      return UserModel(name: '', password: '');
    }
  }

  Future<void> signIn(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = AsyncValue.error(
          'Usuario y contraseña son requeridos', StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    print('🔵 UserState: UserLoading');

    try {
      final user = await _signInUsecase(username, password);

      if (user != null) {
        await _appPrefs.setUser(user);
        state = AsyncValue.data(user);
        print('🟢 UserState: UserAuthenticated - ${user.name}');
      } else {
        state = AsyncValue.error(
            'Usuario o contraseña incorrectos', StackTrace.current);
        print('🔴 UserState: UserError - Credenciales incorrectas');
      }
    } catch (e, st) {
      state = AsyncValue.error('Error al iniciar sesión: ${e.toString()}', st);
    }
  }

  Future<void> signUp(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = AsyncValue.error(
          'Usuario y contraseña son requeridos', StackTrace.current);
      return;
    }

    if (password.length < 6) {
      state = AsyncValue.error(
          'La contraseña debe tener al menos 6 caracteres', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final user = await _signUpUsecase(username, password);

      if (user != null) {
        state = AsyncValue.data(user);
        await _appPrefs.setUser(user);
      } else {
        state = AsyncValue.error(
            'No se pudo crear el usuario. Puede que ya exista.',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(
          'Error al registrarse: ${e.toString()}', StackTrace.current);
    }
  }

  void signOut() {
    state = AsyncValue.data(UserModel(name: '', password: ''));
  }

  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(UserModel(name: '', password: ''));
    }
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
