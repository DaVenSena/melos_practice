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
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    await ref.read(userProvider.notifier).checkUser();

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const SplashScreen();
    }

    final userState = ref.watch(userProvider);

    return userState.when(
      initial: () => const SignInScreen(),
      loading: () => const SplashScreen(),
      authenticated: () => HomeScreen(),
      error: (message) => const SignInScreen(),
    );
  }
}

extension UserStateExtension on UserState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() authenticated,
    required T Function(String message) error,
  }) {
    final state = this;
    if (state is UserInitial) {
      return initial();
    } else if (state is UserLoading) {
      return loading();
    } else if (state is UserAuthenticated) {
      return authenticated();
    } else if (state is UserError) {
      return error(state.message);
    }
    throw Exception('Estado no manejado: $state');
  }
}
