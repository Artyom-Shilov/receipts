import 'package:flutter/widgets.dart';

import '../../common/models/recipe.dart';

abstract interface class BaseRecipesController with ChangeNotifier {
  Future<void> initRecipes();
  List<Recipe> get recipesList;
  Recipe? findRecipeById(String id);
}