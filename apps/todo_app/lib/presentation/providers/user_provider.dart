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

sealed class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserAuthenticated extends UserState {
  final UserModel user;
  const UserAuthenticated(this.user);
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserInitial();
  }

  SignInUsecase get _signInUsecase => ref.read(signInUsecaseProvider);
  SignUpUsecase get _signUpUsecase => ref.read(signUpUsecaseProvider);
  AppPrefs get _appPrefs => ref.read(appPrefsProvider);

  Future<void> checkUser() async {
    final user = await _appPrefs.getUser();
    if (user != null) {
      state = UserAuthenticated(user);
    } else {
      state = const UserInitial();
    }
  }

  Future<void> signIn(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = const UserError('Usuario y contraseña son requeridos');
      return;
    }

    state = const UserLoading();
    print('🔵 UserState: UserLoading');

    try {
      final user = await _signInUsecase(username, password);

      if (user != null) {
        await _appPrefs.setUser(user);
        state = UserAuthenticated(user);
        print('🟢 UserState: UserAuthenticated - ${user.name}');
      } else {
        state = const UserError('Usuario o contraseña incorrectos');
        print('🔴 UserState: UserError - Credenciales incorrectas');
      }
    } catch (e) {
      state = UserError('Error al iniciar sesión: ${e.toString()}');
      print('🔴 UserState: UserError - Exception: $e');
    }
  }

  Future<void> signUp(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = const UserError('Usuario y contraseña son requeridos');
      return;
    }

    if (password.length < 6) {
      state = const UserError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    state = const UserLoading();

    try {
      final user = await _signUpUsecase(username, password);

      if (user != null) {
        state = UserAuthenticated(user);
        await _appPrefs.setUser(user);
      } else {
        state = const UserError(
          'No se pudo crear el usuario. Puede que ya exista.',
        );
      }
    } catch (e) {
      state = UserError('Error al registrarse: ${e.toString()}');
    }
  }

  void signOut() {
    state = const UserInitial();
  }

  void clearError() {
    if (state is UserError) {
      state = const UserInitial();
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
