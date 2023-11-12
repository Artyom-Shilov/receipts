import 'package:bloc/bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/common/models/user.dart';

import 'base_auth_cubit.dart';

class AuthCubit extends Cubit<AuthState> implements BaseAuthCubit {
  AuthCubit() : super(const AuthState(status: AuthStatus.loggedOut));

  @override
  Future<void> logIn({required String login, required String password}) async {
    emit(state.copyWith(status: AuthStatus.inProgress));
    //some request here with login and password to get user
    emit(state.copyWith(
        status: AuthStatus.loggedIn,
        user: User(
            id: 1,
            login: login,
            password: password,
            token: 'testToken',
            avatar: 'assets/sample_data/user_sample_avatar.png')));
  }

  @override
  Future<void> logOut() async {
    emit(state.copyWith(status: AuthStatus.loggedOut, user: null));
  }

  @override
  Future<void> registerUser(
      {required String login, required String password}) async {
    //for now the same logic as login
    emit(state.copyWith(status: AuthStatus.inProgress));
    emit(state.copyWith(
        status: AuthStatus.loggedIn,
        user: User(
            id: 1,
            login: login,
            password: password,
            token: 'testToken',
            avatar: 'assets/sample_data/user_sample_avatar.png')));
  }

  @override
  bool isLoggedIn() {
    return state.status == AuthStatus.loggedIn;
  }
}
