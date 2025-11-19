import 'package:domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/providers/user_provider.dart';
import 'package:todo_app/presentation/views/auth/signin_screen.dart';
import 'package:todo_app/presentation/views/home/home_screen.dart';
import 'package:todo_app/presentation/views/splash.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    if (userState.isLoading) {
      return const SplashScreen();
    }

    return UserStateExtension(userState).when(
      initial: () => const SignInScreen(),
      loading: () => const SplashScreen(),
      authenticated: () => HomeScreen(),
      error: (message) => const SignInScreen(),
    );
  }
}

extension UserStateExtension on AsyncValue<UserModel> {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() authenticated,
    required T Function(String message) error,
  }) {
    final state = this;
    if (!state.hasValue && state.value?.id != null) {
      return initial();
    } else if (state.isLoading) {
      return loading();
    } else if (state.value?.id != null && state.hasValue) {
      return authenticated();
    } else if (state.hasError) {
      return error(state.error.toString());
    }
    throw Exception('Estado no manejado: $state');
  }
}
