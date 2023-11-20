import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseRecipeService {

  Future<void> loadRecipes();
  Future<void> saveRecipeInfo(Recipe recipe);
  Stream<List<Recipe>> get recipes;
}