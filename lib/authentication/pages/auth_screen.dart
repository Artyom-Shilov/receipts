import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_process_cubit.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/authentication/pages/auth_error_page.dart';
import 'package:receipts/authentication/pages/auth_page.dart';
import 'package:receipts/common/constants/constants.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.accent,
        body: BlocBuilder<BaseAuthCubit, AuthState>(
          builder: (context, state) {
            return switch(state.status) {
              AuthStatus.inProgress => const Center(child: CircularProgressIndicator()),
              AuthStatus.loggedIn || AuthStatus.loggedOut => BlocProvider<BaseAuthProcessCubit>(
                create: (context) => AuthProcessCubit(),
                child: const AuthPage()),
             AuthStatus.error => const AuthErrorPage()
            };
          },
        ),
      ),
    );
  }
}
