import 'package:flutter/cupertino.dart';
import 'package:receipts/common/models/user.dart';

abstract interface class BaseAuthController with ChangeNotifier {

  void loginUser({required String login, required String password});
  void registerUser({required String login, required String password});
  void logout();
  User? get currentUser;
  bool get isLoggedIn;
}