import 'package:flutter/widgets.dart';
import 'package:receipts/recipes_list/controllers/base_recipes_controller.dart';
import 'package:receipts/recipes_list/services/base_recipe_service.dart';

import '../../common/models/recipe.dart';

class RecipesController with ChangeNotifier implements BaseRecipesController {

  late List<Recipe> _recipes;
  final BaseRecipeService _recipeService;

  RecipesController(this._recipeService);

  @override
  Future<void> initRecipes() async {
    _recipes = await _recipeService.loadRecipes();
  }

  @override
  List<Recipe> get recipesList => List.unmodifiable(_recipes);

  @override
  Recipe? findRecipeById(String id) {
    try {
      return _recipes.firstWhere((element) => element.id == id);
    } catch (exception) {
     return null;
    }
  }
}