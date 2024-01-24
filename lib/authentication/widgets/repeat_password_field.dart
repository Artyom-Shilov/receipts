import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/app_texts.dart';

class RepeatPasswordField extends HookWidget {
  const RepeatPasswordField({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController =
    useAnimationController(duration: const Duration(milliseconds: 400));
    final authProcessCubit = BlocProvider.of<BaseAuthProcessCubit>(context);
    return BlocConsumer<BaseAuthProcessCubit, AuthProcessState>(
        listenWhen: (prev, next) => prev.process != next.process,
        listener: (context, state) {
      state.process == ProcessStatus.registration
          ? animationController.forward()
          : animationController.reverse();
    }, builder: (context, state) {
      return AnimatedBuilder(
        animation: animationController,
        builder: (context,_) => Opacity(
          opacity: animationController.value,
          child: InputField(
              readOnly: state.process == ProcessStatus.login ? true : false,
              isObscured: true,
              hintText: LoginPageTexts.repeatPasswordHint,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              textController: authProcessCubit.repeatPasswordController,
              validator: state.process == ProcessStatus.login
                  ? null : authProcessCubit.repeatPasswordValidation),
        ),
      );
    });
  }
}
