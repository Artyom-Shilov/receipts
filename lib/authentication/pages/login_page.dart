import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController loginController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 230,
                              ),
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
                                  if (_formKey.currentState!.validate()) {
                                    await BlocProvider.of<BaseAuthCubit>(
                                            context)
                                        .logIn(
                                            login: loginController.text,
                                            password: passwordController.text);
                                    loginController.clear();
                                    passwordController.clear();
                                    if (mounted) {
                                      GoRouter.of(context)
                                          .go('/${AppTabs.recipes}');
                                    }
                                  }
                                },
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
