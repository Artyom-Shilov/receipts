import 'network_models/network_ingredient.dart';
import 'network_models/network_measure_unit.dart';
import 'network_models/network_recipe.dart';
import 'network_models/network_recipe_step.dart';
import 'network_models/recipe_ingredient_link.dart';
import 'network_models/recipe_step_link.dart';

abstract interface class BaseNetworkRecipeClient {

  Future<List<NetworkRecipe>> getRecipes();
  Future<List<RecipeStepLink>> getRecipeStepLinks();
  Future<NetworkRecipeStep> getRecipeStepById(int id);
  Future<List<RecipeIngredientLink>> getRecipeIngredientsLinks();
  Future<NetworkIngredient> getIngredientById(int id);
  Future<NetworkMeasureUnit> getMeasureUnitById(int id);
}
