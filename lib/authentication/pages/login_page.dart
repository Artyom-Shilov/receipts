import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/widgets/animated_auth_button.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/navigation/base_navigation_cubit.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final GlobalKey<FormState> formKey;
    late final TextEditingController loginController;
    late final TextEditingController passwordController;
    useEffect(() {
      loginController = TextEditingController();
      passwordController = TextEditingController();
      formKey = GlobalKey<FormState>();
      return () {
        loginController.dispose();
        passwordController.dispose();
      };
    });
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.accent,
        body: BlocBuilder<BaseAuthCubit, AuthState>(
          builder: (context, state) {
            final navigator = BlocProvider.of<BaseNavigationCubit>(context);
            final authCubit = BlocProvider.of<BaseAuthCubit>(context);
            return state.status == AuthStatus.inProgress
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 230,
                          child: Form(
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
                                InputField(
                                    isObscured: false,
                                    hintText: LoginPageTexts.loginHint,
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    textController: loginController,
                                    validator:
                                        BlocProvider.of<BaseAuthCubit>(context)
                                            .loginValidation),
                                const SizedBox(height: 16),
                                InputField(
                                    isObscured: true,
                                    hintText: LoginPageTexts.passwordHint,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    textController: passwordController,
                                    validator:
                                        BlocProvider.of<BaseAuthCubit>(context)
                                            .passwordValidation),
                                const SizedBox(height: 16),
                                AnimatedOpacity(
                                  opacity: state.process == Process.login ? 0 : 1,
                                  duration: Duration(milliseconds: 400),
                                  child: InputField(
                                      isObscured: true,
                                      hintText: LoginPageTexts.passwordHint,
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      textController: passwordController,
                                      validator:
                                      BlocProvider.of<BaseAuthCubit>(context)
                                          .passwordValidation),
                                ),
                                SizedBox(height: 150),
                                TextButton(
                                  child: Text(
                                      state.process == Process.login
                                          ? LoginPageTexts.toRegisterToggle
                                          : LoginPageTexts.toLoginToggle,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    log(state.process.name);
                                    state.process == Process.login
                                        ? authCubit.startRegistration()
                                        : authCubit.startLogin();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedAuthButton(loginController: loginController, passwordController: passwordController, passwordRepeatController: passwordController, formKey: formKey)
                    ]),
                  );
          },
        ),
      ),
    );
  }
}
