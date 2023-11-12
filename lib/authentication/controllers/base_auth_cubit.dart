import 'package:bloc/bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';

abstract interface class BaseAuthCubit extends Cubit<AuthState> {
  BaseAuthCubit() : super(const AuthState(status: AuthStatus.loggedOut));
  Future<void> logIn({required String login, required String password});
  Future<void> registerUser({required String login, required String password});
  Future<void> logOut();
  bool isLoggedIn();
}