import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/network/network_models/recipe_ingredient_link.dart';
import 'package:receipts/common/network/network_models/recipe_step_link.dart';
import 'package:rxdart/subjects.dart';
import 'base_recipe_repository.dart';

class RecipeRepository implements BaseRecipeRepository {

  RecipeRepository(
      {required BaseStorageRecipeClient storageClient,
      required BaseNetworkRecipeClient networkClient})
      : _storageClient = storageClient,
        _networkClient = networkClient;

  final BaseStorageRecipeClient _storageClient;
  final BaseNetworkRecipeClient _networkClient;

  final _recipeListController = BehaviorSubject<List<Recipe>>.seeded([]);

  StreamSink<List<Recipe>> get _recipeListSink => _recipeListController.sink;

  @override
  Stream<List<Recipe>> get recipes => _recipeListController.stream;

  @override
  Future<void> loadRecipes() async {
    List<Recipe> recipes;
    try {
      recipes = [];
      final networkRecipes = await _networkClient.getRecipes();
      final ingredientsLinks = await _networkClient.getRecipeIngredientsLinks();
      final stepLinks = await _networkClient.getRecipeStepLinks();
      for (final networkRecipe in networkRecipes) {
        final steps = <CookingStep>[];
        final ingredients = <Ingredient>[];
        final filteredIngredientsLinks = ingredientsLinks
            .where((element) => element.recipe.id == networkRecipe.id);
        final filteredStepLinks =
        stepLinks.where((element) => element.recipe.id == networkRecipe.id);
        for (final stepLink in filteredStepLinks) {
          steps.add(await _formLocalStepFromNet(stepLink));
        }
        for (final ingredientLink in filteredIngredientsLinks) {
          ingredients.add(await _formLocalIngredientFromNet(ingredientLink));
        }
        recipes.add(Recipe(
            id: networkRecipe.id,
            name: networkRecipe.name,
            photo: networkRecipe.photo,
            duration: networkRecipe.duration.toString(),
            steps: steps,
            ingredients: ingredients,
            comments: []));
      }
    } catch (e) {
      _recipeListSink.addError(e);
      return;
    }
    _recipeListSink.add(recipes);
  }

  Future<CookingStep> _formLocalStepFromNet(RecipeStepLink stepLink) async {
    final loadedStep = await _networkClient.getRecipeStepById(stepLink.step.id);
    return CookingStep(
        id: loadedStep.id,
        number: stepLink.number.toString(),
        description: loadedStep.name,
        duration: loadedStep.duration.toString());
  }

  Future<Ingredient> _formLocalIngredientFromNet(
      RecipeIngredientLink ingredientLink) async {
    final loadedIngredient =
    await _networkClient.getIngredientById(ingredientLink.ingredient.id);
    final loadedMeasureUnit =
    await _networkClient.getMeasureUnitById(loadedIngredient.measureUnit.id);
    String measure = ingredientLink.count % 10 == 1
        ? loadedMeasureUnit.one
        : ingredientLink.count % 10 <= 4
        ? loadedMeasureUnit.few
        : loadedMeasureUnit.many;
    return Ingredient(
        id: loadedIngredient.id,
        count: ingredientLink.count.toString(),
        name: loadedIngredient.name,
        measureUnit: measure);
  }

  @override
  Future<void> saveRecipeInfo(Recipe recipe) async {
    List<Recipe> recipeList;
    try {
      recipeList = [..._recipeListController.value];
      int index = recipeList.indexWhere((element) => element.id == recipe.id);
      recipeList[index] = recipe;
      _storageClient.writeRecipes(recipeList);
    } catch (e) {
      _recipeListSink.addError(e);
      return;
    }
    _recipeListSink.add(recipeList);
  }
}
