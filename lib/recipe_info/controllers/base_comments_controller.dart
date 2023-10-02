import 'package:flutter/cupertino.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseCommentsController with ChangeNotifier {

  List<Comment> get comments;
  Future<void> updateCommentsOfRecipe(Recipe recipe);
  Future<void> saveComment({required Recipe recipe, required Comment comment});
}