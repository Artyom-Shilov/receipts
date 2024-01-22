import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/authentication/widgets/input_field.dart';
import 'package:receipts/common/constants/app_texts.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProcessCubit = BlocProvider.of<BaseAuthProcessCubit>(context);
    return InputField(
        readOnly: false,
        isObscured: true,
        hintText: LoginPageTexts.passwordHint,
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        textController: authProcessCubit.passwordController,
        validator: authProcessCubit.passwordValidation);
  }
}
