import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseRecipeService {

  Future<List<Recipe>> loadRecipes();
}