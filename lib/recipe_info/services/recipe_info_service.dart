import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/services/base_recipe_info_service.dart';

class RecipeInfoService implements BaseRecipeInfoService {
  RecipeInfoService();

  @override
  Future<Recipe> getRecipeById({required String id, required List<Recipe> recipes}) async {
    return recipes.firstWhere((element) => element.id == id);
  }
}
