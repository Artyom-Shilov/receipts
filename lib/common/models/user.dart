import 'package:receipts/common/models/recipe.dart';

import 'comment.dart';

class User {
  int id;
  String login;
  String password;
  String token;
  String avatar;
  List<Comment>? comments;
  List<Recipe>? favourite;

  User(
      {required this.id,
      required this.login,
      required this.password,
      required this.token,
      required this.avatar,
      this.favourite,
      this.comments});
}