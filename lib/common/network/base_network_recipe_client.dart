import 'dart:typed_data';

import 'package:receipts/common/network/network_models/network_comment.dart';
import 'package:receipts/common/network/network_models/network_favourite.dart';
import 'package:receipts/common/network/network_models/network_models.dart';


abstract interface class BaseNetworkRecipeClient {
  Future<List<NetworkRecipe>> getRecipes();

  Future<List<RecipeStepLink>> getRecipeStepLinks();

  Future<NetworkRecipeStep> getRecipeStepById(int id);

  Future<List<RecipeIngredientLink>> getRecipeIngredientsLinks();

  Future<NetworkIngredient> getIngredientById(int id);

  Future<NetworkMeasureUnit> getMeasureUnitById(int id);

  Future<Uint8List> getImage(String imageUrl);

  Future<List<NetworkFavourite>> getFavourites();

  Future<int> markAsFavourite(int recipeId, int userId);

  Future<void> unmarkFavourite(int favouriteId);

  Future<int> sendComment(
      {required String text,
      required String photo,
      required String datetime,
      required int userId,
      required int recipeId});

  Future<List<NetworkComment>> getComments();

  Future<NetworkUser> getUserById(int id);

  Future<String> registerUser({required String login, required String password});

  Future<String> loginUser({required String login, required String password});
}
