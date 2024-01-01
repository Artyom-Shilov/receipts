
import 'storage_models/storage_models.dart';

abstract interface class BaseStorageRecipeClient {

  Future<void> init(String path);
  Future<void> writeRecipes(List<LocalRecipe> recipes);
  Future<List<LocalRecipe>> readRecipes();
  Future<void> updateRecipe(LocalRecipe recipe);
  Future<List<LocalUserRecipePhoto>> getLocalUserRecipePhotosByRecipeId(int id);
}