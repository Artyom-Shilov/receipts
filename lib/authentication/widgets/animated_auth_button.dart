import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';

class AnimatedAuthButton extends HookWidget {
  const AnimatedAuthButton({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 400));
    final buttonTextAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1.0), weight: 30),
    ]).animate(controller);
    final authProcessCubit = BlocProvider.of<BaseAuthProcessCubit>(context);
    final authCubit = BlocProvider.of<BaseAuthCubit>(context);
    final navigator = BlocProvider.of<BaseNavigationCubit>(context);
    bool? isFromErrorValidation;
    return BlocConsumer<BaseAuthProcessCubit, AuthProcessState>(
        listenWhen: (prev, next) {
          isFromErrorValidation = prev.isFormValidationError;
          return prev.process != next.process;
        },
        listener: (context, state) {
      state.process == ProcessStatus.registration
          ? controller.forward()
          : controller.reverse();
    }, builder: (context, state) {
      final paddingAnimation = state.isFormValidationError
          ? Tween<double>(begin: 550, end: 630).animate(controller)
          : Tween<double>(
                  begin: (isFromErrorValidation == true &&
                          state.process == ProcessStatus.registration)
                      ? 550
                      : 500,
                  end: isFromErrorValidation == true &&
                          state.process == ProcessStatus.login
                      ? 630
                      : 580)
              .animate(controller);
      return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Padding(
              padding: EdgeInsets.only(top: paddingAnimation.value),
              child: Center(
                child: ControlButton(
                  backgroundColor: AppColors.main,
                  borderColor: AppColors.main,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          final login = authProcessCubit.loginController.text;
                          final password =
                              authProcessCubit.passwordController.text;
                          state.process == ProcessStatus.login
                              ? await authCubit.logIn(
                                  login: login, password: password)
                              : await authCubit.registerUser(
                                  login: login, password: password);
                          authProcessCubit.clearTextControllers();
                          authCubit.status == AuthStatus.loggedIn
                              ? navigator.toRecipeList()
                              : null;
                        } else {
                          BlocProvider.of<BaseAuthProcessCubit>(context)
                              .setFieldValidationErrorFlag();
                        }
                      },
                      child: Opacity(
                    opacity: buttonTextAnimation.value,
                    child: Text(
                      controller.value < 0.5
                          ? LoginPageTexts.doLogin
                          : LoginPageTexts.doRegister,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}
