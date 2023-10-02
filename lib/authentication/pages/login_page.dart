import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
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
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.accent,
        body: SingleChildScrollView(
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
                      'Otus.Food',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    InputField(
                      isObscured: false,
                      hintText: 'логин',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      textController: loginController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : 'Введите логин';
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputField(
                      isObscured: true,
                      hintText: 'пароль',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      textController: passwordController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : 'Введите пароль';
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ControlButton(
                      text: const Text(
                        'Войти',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.main,
                      borderColor: AppColors.main,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          context.read<BaseAuthController>().loginUser(
                              login: loginController.text,
                              password: passwordController.text);
                          context.goNamed(AppRouteNames.home.name,
                              pathParameters: {
                                AppPathParameters.tab.name: AppTabs.recipes.name
                              });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    MaterialButton(
                      child: const Text(
                        'Зарегистрироваться',
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
        ),
      ),
    );
  }
}
