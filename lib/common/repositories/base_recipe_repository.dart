import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseRecipeRepository {

  Future<void> loadRecipes();
  Future<void> saveRecipeInfo(Recipe recipe);
  Stream<List<Recipe>> get recipes;
}