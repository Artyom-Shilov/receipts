import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_process_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/authentication/pages/auth_page.dart';
import 'package:receipts/common/constants/app_colors.dart';

class AuthErrorPage extends HookWidget {
  const AuthErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<BaseAuthCubit>(context);
    useEffect(() {
      Future.delayed(
          Duration.zero,
              () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                content: Text(authCubit.state.message),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.done, color: AppColors.accent),
                    onPressed: () {
                      authCubit.logOut();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )));
      return null;
    });
    return BlocProvider<BaseAuthProcessCubit>(
        create: (context) => AuthProcessCubit(),
        child: const AuthPage());
  }
}
