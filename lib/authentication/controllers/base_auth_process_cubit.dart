import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:receipts/authentication/controllers/auth_process_state.dart';

abstract interface class BaseAuthProcessCubit extends Cubit<AuthProcessState> {
  BaseAuthProcessCubit(super.initialState);

  String? Function(String? login) get loginValidation;
  String? Function(String? password) get passwordValidation;
  String? Function(String? repeatedPassword) get repeatPasswordValidation;
  void startRegistration();
  void startLogin();
  void setFieldValidationErrorFlag();
  void removeFieldValidationErrorFlag();
  TextEditingController get loginController;
  TextEditingController get passwordController;
  TextEditingController get repeatPasswordController;
  void clearTextControllers();
}