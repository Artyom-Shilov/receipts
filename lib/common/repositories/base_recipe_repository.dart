import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user.dart';

abstract interface class BaseRecipeRepository {

  Future<void> loadRecipes();
  Future<void> saveRecipeInfo(Recipe recipe);
  Stream<List<Recipe>> get recipesStream;
  List<Recipe> get currentRecipes;
  Future<void> setLoggedUserFavouriteRecipes(User user);
  Future<void> loadComments();
}