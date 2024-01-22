import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/common/constants/app_texts.dart';

class ProcessSwitchButton extends StatelessWidget {
  const ProcessSwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProcessCubit = BlocProvider.of<BaseAuthProcessCubit>(context);
    return BlocBuilder<BaseAuthProcessCubit, AuthProcessState>(
      builder: (context, state) {
        return TextButton(
          child: Text(
            state.process == ProcessStatus.login
                ? LoginPageTexts.toRegisterToggle
                : LoginPageTexts.toLoginToggle,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w100, color: Colors.white),
          ),
          onPressed: () {
            state.process == ProcessStatus.login
                ? authProcessCubit.startRegistration()
                : authProcessCubit.startLogin();
          },
        );
      },
    );
  }
}
