import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user.dart';

abstract interface class BaseRecipeInfoService {

  Recipe getRecipeById({required String id,  required List<Recipe> recipes});
  void saveComment({required Comment comment, required Recipe recipe, required User user});
}