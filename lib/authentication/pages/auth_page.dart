import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/authentication/widgets/widgets.dart';
import 'package:receipts/common/constants/constants.dart';

class AuthPage extends HookWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final GlobalKey<FormState> formKey;
    useEffect(() {
      formKey = GlobalKey<FormState>();
      return null;
    });
    return SingleChildScrollView(
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 230,
            child: BlocBuilder<BaseAuthProcessCubit, AuthProcessState>(
              buildWhen: (prev, next) => prev.process != next.process,
              builder: (context, state) => Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 200),
                    const Text(
                      LoginPageTexts.appName,
                      style: TextStyle(
                          fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 80),
                    const LoginInputField(),
                    const SizedBox(height: 16),
                    const PasswordInputField(),
                    const SizedBox(height: 16),
                    const RepeatPasswordField(),
                    const SizedBox(height: 150),
                    ProcessSwitchButton(formKey: formKey),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedAuthButton(formKey: formKey)
      ]),
    );
  }
}
