import 'package:bloc/bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/common/models/user.dart';

abstract interface class BaseAuthCubit extends Cubit<AuthState> {
  BaseAuthCubit() : super(const AuthState(status: AuthStatus.loggedOut));
  Future<void> logIn({required String login, required String password});
  Future<void> registerUser({required String login, required String password});
  Future<void> logOut();
  bool get isLoggedIn;
  AuthStatus get status;
  User? get currentUser;
  String? Function(String? login) get loginValidation;
  String? Function(String? passowrd) get passwordValidation;
  void startRegistration();
  void startLogin();

}