import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:rxdart/subjects.dart';
import 'base_recipe_service.dart';

class RecipeService implements BaseRecipeService {
  final _sampleRecipesFile = 'assets/sample_data/recipes_samples.json';

  RecipeService();

  final _recipeListController = BehaviorSubject<List<Recipe>>.seeded([]);

  StreamSink<List<Recipe>> get _recipeListSink => _recipeListController.sink;

  @override
  Stream<List<Recipe>> get recipes => _recipeListController.stream;

  @override
  Future<void> loadRecipes() async {
    List<Recipe> recipes;
    try {
      await Future.delayed(const Duration(seconds: 2));
      final recipesString = await rootBundle.loadString(_sampleRecipesFile);
      final List<dynamic> recipesJson = jsonDecode(recipesString);
      recipes = recipesJson.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      _recipeListSink.addError(e);
      return;
    }
    _recipeListSink.add(recipes);
  }

  @override
  Future<void> saveRecipeInfo(Recipe recipe) async {
    List<Recipe> recipeList;
    try {
      recipeList = [..._recipeListController.value];
      int index = recipeList.indexWhere((element) => element.id == recipe.id);
      recipeList[index] = recipe;
    } catch (e) {
      _recipeListSink.addError(e);
      return;
    }
    _recipeListSink.add(recipeList);
  }
}
