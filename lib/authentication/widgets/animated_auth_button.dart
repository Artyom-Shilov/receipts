import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/widgets/control_button.dart';

class AnimatedAuthButton extends HookWidget{
  const AnimatedAuthButton({Key? key, required this.loginController, required this.passwordController, required this.passwordRepeatController, required this.formKey}) : super(key: key);

  final TextEditingController loginController;
  final TextEditingController passwordController;
  final TextEditingController passwordRepeatController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 400));
    final paddingAnimation = Tween<double>(begin: 470, end: 550).animate(controller);
    final buttonTextAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1.0), weight: 30),
    ]).animate(controller);
    return BlocListener<BaseAuthCubit, AuthState>(
      listenWhen: (prev, next) => prev.process != next.process,
      listener: (context, state) {
        state.process == Process.registration ? controller.forward() : controller.reverse();
      },
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Padding(
              padding: EdgeInsets.only(
                top: paddingAnimation.value
              ),
              child: Center(
                child: ControlButton(
                  backgroundColor: AppColors.main,
                  borderColor: AppColors.main,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (formKey.currentState!.validate()) {
                      await BlocProvider.of<BaseAuthCubit>(context)
                          .logIn(login: loginController.text, password: passwordController.text);
                      loginController.clear();
                      passwordController.clear();
                     // navigator.toRecipeList();
                    }
                  },
                  child: Opacity(
                    opacity: buttonTextAnimation.value,
                    child: Text(
                      controller.value < 0.5
                          ? LoginPageTexts.doLogin
                          : LoginPageTexts.doRegister,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
