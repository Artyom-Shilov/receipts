import 'package:flutter/cupertino.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import '../models/user.dart';

class AuthController with ChangeNotifier implements BaseAuthController {

  late User _user;

  AuthController() {
    _user = User(id: 1, login: '', password: '', token: '', avatar: '');
  }

  @override
  bool get isLoggedIn => _user.token != '';

  @override
  void loginUser({required String login, required String password}) {
    _user
      ..login = login
      ..password = password
      ..avatar = 'assets/sample_data/user_sample_avatar.png'
      ..token = 'test';

    notifyListeners();
  }

  @override
  void registerUser({required String login, required String password}) {
    _user
      ..login = login
      ..password = password
      ..token = 'test';
    notifyListeners();
  }

  @override
  void logout() {
    _user.token = '';
  }

  @override
  User? get currentUser => _user;
}
