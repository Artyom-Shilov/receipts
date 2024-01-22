import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';
import 'package:receipts/authentication/controllers/base_auth_process_cubit.dart';
import 'package:receipts/common/constants/app_texts.dart';

class AuthProcessCubit extends Cubit<AuthProcessState>
    implements BaseAuthProcessCubit {
  AuthProcessCubit()
      : loginController = TextEditingController(),
        passwordController = TextEditingController(),
        repeatPasswordController = TextEditingController(),
        super(const AuthProcessState());

  @override
  TextEditingController loginController;
  @override
  TextEditingController passwordController;
  @override
  TextEditingController repeatPasswordController;

  @override
  void startRegistration() {
    emit(state.copyWith(process: ProcessStatus.registration));
  }

  @override
  void startLogin() {
    emit(state.copyWith(process: ProcessStatus.login));
  }

  @override
  void setFieldValidationErrorFlag() {
    emit(state.copyWith(isFormValidationError: true));
  }

  @override
  void removeFieldValidationErrorFlag() {
    emit(state.copyWith(isFormValidationError: false));
  }

  @override
  String? Function(String? login) get loginValidation => (value) =>
      value!.isNotEmpty ? null : LoginPageTexts.inputLoginValidatorMessage;

  @override
  String? Function(String? password) get passwordValidation => (value) =>
      value!.isNotEmpty ? null : LoginPageTexts.inputPasswordValidatorMessage;

  @override
  String? Function(String? repeatedPassword) get repeatPasswordValidation =>
      (value) {
        if (value!.isEmpty) {
          return LoginPageTexts.inputRepeatPasswordValidatorMessage;
        } else if (value != passwordController.value.text) {
          return LoginPageTexts.invalidRepeatPasswordValidatorMessage;
        }
        return null;
      };

  @override
  Future<void> close() {
    loginController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    return super.close();
  }

  @override
  void clearTextControllers() {
    if(!isClosed) {
      loginController.clear();
      passwordController.clear();
      repeatPasswordController.clear();
    }
  }
}