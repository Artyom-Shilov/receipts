import 'user.dart';
import 'recipe.dart';

class Comment {
  String text;
  String photo;
  String datetime;
  User? user;
  Recipe? recipe;

  Comment(
      {required this.text,
      required this.photo,
      required this.datetime,
      this.user,
      this.recipe});
}
