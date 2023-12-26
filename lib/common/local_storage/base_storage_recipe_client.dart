
import 'package:receipts/common/local_storage/storage_models/local_recipe.dart';

abstract interface class BaseStorageRecipeClient {

  Future<void> init(String path);
  Future<void> writeRecipes(List<LocalRecipe> recipes);
  Future<List<LocalRecipe>> readRecipes();
  Future<void> updateRecipe(LocalRecipe recipe);
}