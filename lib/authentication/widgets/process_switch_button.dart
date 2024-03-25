import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/common/constants/app_texts.dart';

class ProcessSwitchButton extends StatelessWidget {
  const ProcessSwitchButton({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final authProcessCubit = BlocProvider.of<BaseAuthProcessCubit>(context);
    return TextButton(
      child: Text(
        authProcessCubit.state.process == ProcessStatus.login
            ? LoginPageTexts.toRegisterToggle
            : LoginPageTexts.toLoginToggle,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w100, color: Colors.white),
      ),
      onPressed: () {
        if (authProcessCubit.state.process == ProcessStatus.login) {
          formKey.currentState!.reset();
          authProcessCubit.startRegistration();
        } else {
          formKey.currentState!.reset();
          authProcessCubit.startLogin();
        }
      },
    );
  }
}
