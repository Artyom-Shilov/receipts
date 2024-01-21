import 'package:bloc/bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/user.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';

import 'base_auth_cubit.dart';

class AuthCubit extends Cubit<AuthState> implements BaseAuthCubit {
  AuthCubit(BaseRecipeRepository recipeRepository)
      : _recipeRepository = recipeRepository,
      super(const AuthState(status: AuthStatus.loggedOut, process: Process.login));

  final BaseRecipeRepository _recipeRepository;

  final _userId = 4;

  @override
  Future<void> logIn({required String login, required String password}) async {
    emit(state.copyWith(status: AuthStatus.inProgress));
    final user = User(
        id: _userId,
        login: login,
        password: password,
        token: '',
        avatar: null);
    await _recipeRepository.setLoggedUserFavouriteRecipes(user);
    await _recipeRepository.loadComments();
    emit(state.copyWith(
        status: AuthStatus.loggedIn,
        user: user));
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
            id: _userId,
            login: login,
            password: password,
            token: 'testToken',
            avatar: null)));
  }

  @override
  User? get currentUser => state.user;

  @override
  bool get isLoggedIn => state.status == AuthStatus.loggedIn;

  @override
  AuthStatus get status => state.status;

  @override
  String? Function(String? login) get loginValidation => (value) =>
      value!.isNotEmpty ? null : LoginPageTexts.loginValidatorMessage;

  @override
  String? Function(String? passowrd) get passwordValidation => (value) =>
      value!.isNotEmpty ? null : LoginPageTexts.passwordValidatorMessage;

  @override
  void startRegistration() {
    emit(state.copyWith(process: Process.registration));
  }

  @override
  void startLogin() {
    emit(state.copyWith(process: Process.login));
  }


}