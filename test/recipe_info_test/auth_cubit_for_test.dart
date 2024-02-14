import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/models/user.dart';

class AuthCubitForTest extends Cubit<AuthState> implements BaseAuthCubit {
  AuthCubitForTest()
      : super(const AuthState(
            status: AuthStatus.loggedIn,
            user: User(
                id: 4,
                login: 'test',
                password: 'test',
                token: 'test',
                avatar: null)));

  final _userId = 4;

  @override
  Future<void> logIn({required String login, required String password}) async {
    final user = User(
        id: _userId,
        login: login,
        password: password,
        token: 'token',
        avatar: null);
    emit(state.copyWith(status: AuthStatus.loggedIn, user: user));
  }

  @override
  Future<void> logOut() async {
    emit(state.copyWith(status: AuthStatus.loggedOut, user: null));
  }

  @override
  Future<void> registerUser({required String login, required String password}) async {
    emit(state.copyWith(
        status: AuthStatus.loggedIn,
        user: User(
            id: _userId,
            login: login,
            password: password,
            token: 'token',
            avatar: null)));
  }

  @override
  User? get currentUser => state.user;

  @override
  bool get isLoggedIn => state.status == AuthStatus.loggedIn;

  @override
  AuthStatus get status => state.status;
}