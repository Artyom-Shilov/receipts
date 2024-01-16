import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/navigation/app_router.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final GlobalKey<FormState> formKey;
    late final TextEditingController loginController;
    late final TextEditingController passwordController;
    final goRouter = GoRouter.of(context);
    useEffect(() {
      loginController = TextEditingController();
      passwordController = TextEditingController();
      formKey = GlobalKey<FormState>();
      return ()  {
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
            return state.status == AuthStatus.inProgress
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 230,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 230),
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
                              const SizedBox(height: 40),
                              ControlButton(
                                text: const Text(
                                  LoginPageTexts.doLogin,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.main,
                                borderColor: AppColors.main,
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (formKey.currentState!.validate()) {
                                    await BlocProvider.of<BaseAuthCubit>(
                                            context)
                                        .logIn(
                                            login: loginController.text,
                                            password: passwordController.text);
                                    loginController.clear();
                                    passwordController.clear();
                                    goRouter.go('/${AppTabs.recipes}');
                                    }
                                  }
                                ,
                              ),
                              const SizedBox(height: 100),
                              MaterialButton(
                                child: const Text(
                                  LoginPageTexts.doRegister,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.white),
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
