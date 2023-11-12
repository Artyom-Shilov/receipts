import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user.dart';
import 'package:receipts/recipe_info/services/base_recipe_info_service.dart';

class RecipeInfoService implements BaseRecipeInfoService {
  RecipeInfoService();

  @override
  Recipe getRecipeById({required String id, required List<Recipe> recipes}) {
    return recipes.firstWhere((element) => element.id == id);
  }

  @override
  void saveComment(
      {required Comment comment, required Recipe recipe, required User user}) {
    recipe.comments.add(comment);
  }
}
