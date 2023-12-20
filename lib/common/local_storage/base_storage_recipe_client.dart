import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseStorageRecipeClient {

  Future<void> init(String path);
  Future<void> writeRecipes(List<Recipe> recipes);
  Future<List<Recipe>> readRecipes();
}