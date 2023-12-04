import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';
import 'package:receipts/common/models/recipe.dart';

class HiveRecipeClient implements BaseStorageRecipeClient {

  @override
  Future<void> init(String path) async {
    Hive.init(path);
    Hive.registerAdapter<Recipe>(RecipeAdapter());
    Hive.registerAdapter<CookingStep>(CookingStepAdapter());
    Hive.registerAdapter<Ingredient>(IngredientAdapter());
  }

  @override
  Future<void> writeRecipes(List<Recipe> recipes) async {
    final recipeBox = await Hive.openBox<Recipe>('recipes');
    await recipeBox.clear();
    await recipeBox.addAll(recipes);
    await recipeBox.close();
  }

  @override
  Future<List<Recipe>> readRecipes() async {
    final recipeBox = await Hive.openBox<Recipe>('recipes');
    final recipes = recipeBox.values.toList();
    await recipeBox.close();
    return recipes;
  }
}