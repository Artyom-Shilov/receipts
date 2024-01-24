import 'package:bloc/bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/exceptions/exceptions.dart';
import 'package:receipts/common/exceptions/user_already_exists_exception.dart';
import 'package:receipts/common/models/user.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';

import 'base_auth_cubit.dart';

class AuthCubit extends Cubit<AuthState> implements BaseAuthCubit {
  AuthCubit(BaseRecipeRepository recipeRepository,
      BaseNetworkRecipeClient networkRecipeClient)
      : _recipeRepository = recipeRepository,
        _networkClient = networkRecipeClient,
        super(const AuthState(status: AuthStatus.loggedOut));

  final BaseRecipeRepository _recipeRepository;
  final BaseNetworkRecipeClient _networkClient;

  //we will need user id to send user dependent info such as comments on server, but I don't see  possibility to gain it via network
  final _userId = 4;

  @override
  Future<void> logIn({required String login, required String password}) async {
    emit(state.copyWith(status: AuthStatus.inProgress));
    String token;
    try {
      token = await _networkClient.loginUser(login: login, password: password);
      print(token);
    } on InvalidCredentialsException {
      emit(state.copyWith(
          status: AuthStatus.error, message: ErrorMessages.credentials));
      return;
    } on Exception {
      emit(state.copyWith(
          status: AuthStatus.error, message: ErrorMessages.authBaseError));
      return;
    }
    final user = User(
        id: _userId,
        login: login,
        password: password,
        token: token,
        avatar: null);
    await _recipeRepository.setLoggedUserFavouriteRecipes(user);
    await _recipeRepository.loadComments();
    emit(state.copyWith(status: AuthStatus.loggedIn, user: user));
  }

  @override
  Future<void> logOut() async {
    emit(state.copyWith(status: AuthStatus.loggedOut, user: null));
  }

  @override
  Future<void> registerUser(
      {required String login, required String password}) async {
    emit(state.copyWith(status: AuthStatus.inProgress));
    String token;
    try {
      _networkClient.registerUser(login: login, password: password);
      token = await _networkClient.loginUser(login: login, password: password);
      print(token);
    } on UserAlreadyExistsException {
      emit(state.copyWith(
          status: AuthStatus.error, message: ErrorMessages.userAlreadyExists));
      return;
    } on InvalidCredentialsException {
      emit(state.copyWith(
          status: AuthStatus.error, message: ErrorMessages.credentials));
      return;
    } on Exception {
      emit(state.copyWith(
          status: AuthStatus.error, message: ErrorMessages.authBaseError));
      return;
    }
    emit(state.copyWith(
        status: AuthStatus.loggedIn,
        user: User(
            id: _userId,
            login: login,
            password: password,
            token: token,
            avatar: null)));
  }

  @override
  User? get currentUser => state.user;

  @override
  bool get isLoggedIn => state.status == AuthStatus.loggedIn;

  @override
  AuthStatus get status => state.status;
}