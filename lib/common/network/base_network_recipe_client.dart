import 'dart:typed_data';

import 'package:receipts/common/network/network_models/network_models.dart';


abstract interface class BaseNetworkRecipeClient {

  Future<List<NetworkRecipe>> getRecipes();
  Future<List<RecipeStepLink>> getRecipeStepLinks();
  Future<NetworkRecipeStep> getRecipeStepById(int id);
  Future<List<RecipeIngredientLink>> getRecipeIngredientsLinks();
  Future<NetworkIngredient> getIngredientById(int id);
  Future<NetworkMeasureUnit> getMeasureUnitById(int id);
  Future<Uint8List> getImage(String imageUrl);
}
