import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:receipts/common/models/recipe.dart';

import 'base_recipe_service.dart';

class RecipeService implements BaseRecipeService {
  final _sampleRecipesFile = 'assets/sample_data/recipes_samples.json';

  const RecipeService();

  @override
  Future<List<Recipe>> get sampleRecipes async {
    final recipesString = await rootBundle.loadString(_sampleRecipesFile);
    Map<String, dynamic> recipesJson = jsonDecode(recipesString);
    List<dynamic> jsonList = recipesJson['recipes'] ?? [];
    final recipes = jsonList.map((e) => Recipe.fromJson(e)).toList();
    return recipes;
  }
}
