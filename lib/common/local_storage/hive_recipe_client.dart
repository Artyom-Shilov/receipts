import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';

import 'storage_models/storage_models.dart';

class HiveRecipeClient implements BaseStorageRecipeClient {

  @override
  Future<void> init(String path) async {
    Hive.init(path);
    //Hive.deleteBoxFromDisk('recipes');
   Hive.registerAdapter<LocalRecipe>(LocalRecipeAdapter());
   Hive.registerAdapter<LocalCookingStep>(LocalCookingStepAdapter());
   Hive.registerAdapter<LocalIngredient>(LocalIngredientAdapter());
   Hive.registerAdapter<LocalUserRecipePhoto>(LocalUserRecipePhotoAdapter());
   Hive.registerAdapter<LocalDetection>(LocalDetectionAdapter());
   Hive.registerAdapter<LocalComment>(LocalCommentAdapter());
   Hive.registerAdapter<LocalUser>(LocalUserAdapter());
  }

  @override
  Future<void> writeRecipes(List<LocalRecipe> recipes) async {
   final recipeBox = await Hive.openBox<LocalRecipe>('recipes');
   await recipeBox.clear();
   final recipeMap = {
     for (final recipe in recipes)
       recipe.id : recipe
   };
   await recipeBox.putAll(recipeMap);
   await recipeBox.close();
  }

  @override
  Future<void> updateRecipe(LocalRecipe recipe) async {
    final recipeBox = await Hive.openBox<LocalRecipe>('recipes');
    await recipeBox.put(recipe.id, recipe);
    await recipeBox.close();
  }

  @override
  Future<List<LocalRecipe>> readRecipes() async {
    final recipeBox = await Hive.openBox<LocalRecipe>('recipes');
    final recipes = recipeBox.values.toList();
    await recipeBox.close();
    return recipes;
  }
}