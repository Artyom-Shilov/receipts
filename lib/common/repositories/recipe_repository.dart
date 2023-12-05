import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/network/network_models/network_measure_unit.dart';
import 'package:receipts/common/network/network_models/recipe_ingredient_link.dart';
import 'package:receipts/common/network/network_models/recipe_step_link.dart';
import 'package:receipts/common/repositories/exceptions/empty_storage_exception.dart';
import 'package:receipts/common/repositories/exceptions/load_recipes_local_exception.dart';
import 'package:receipts/common/repositories/exceptions/load_recipes_net_exception.dart';
import 'package:receipts/common/repositories/exceptions/save_recipe_info_exception.dart';
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

  final _recipeListController = BehaviorSubject<List<Recipe>>();

  StreamSink<List<Recipe>> get _recipeListSink => _recipeListController.sink;

  @override
  Stream<List<Recipe>> get recipes => _recipeListController.stream;

  @override
  Future<void> loadRecipes() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    List<Recipe> recipes;
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        try {
          recipes = await _loadRecipesFromNet();
          await _storageClient.writeRecipes(recipes);
        } catch (e) {
          _recipeListSink.addError(LoadRecipesNetException(e));
          return;
        }
      } else {
        try {
          recipes = await _storageClient.readRecipes();
        } catch (e) {
          _recipeListSink.addError(LoadRecipesLocalException(e));
          return;
        }
        if (recipes.isEmpty) {
          _recipeListSink.addError(EmptyStorageException());
          return;
        }
      }
    _recipeListSink.add(recipes);
  }

  Future<CookingStep> _formLocalStepFromNet(RecipeStepLink stepLink) async {
    final loadedStep = await _networkClient.getRecipeStepById(stepLink.step.id);
    final formattedDuration = DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(Duration(minutes: loadedStep.duration).inMilliseconds));
    return CookingStep(
        id: loadedStep.id,
        number: stepLink.number.toString(),
        description: loadedStep.name,
        duration: formattedDuration);
  }

  Future<Ingredient> _formLocalIngredientFromNet(
      RecipeIngredientLink ingredientLink) async {
    final loadedIngredient =
    await _networkClient.getIngredientById(ingredientLink.ingredient.id);
    final loadedMeasureUnit =
    await _networkClient.getMeasureUnitById(loadedIngredient.measureUnit.id);
    return Ingredient(
        id: loadedIngredient.id,
        count: ingredientLink.count.toString(),
        name: loadedIngredient.name,
        measureUnit: _calcMeasureUnit(ingredientLink.count, loadedMeasureUnit)
    );
  }

  String _calcMeasureUnit(int count, NetworkMeasureUnit unit) {

    if (count % 10 == 1) {
      return unit.one;
    }
    if (count % 10 == 0) {
      return unit.many;
    }
    if (count % 10 <= 4) {
      return unit.few;
    }
    return unit.many;
  }

  String _calcRecipeDurationForm(int duration) {
    if (duration % 10 == 1) {
      return TimeUnits.minutesOne;
    }
    if (duration % 10 == 0) {
      return TimeUnits.minutesOne;
    }
    if (duration % 10 <= 4) {
      return TimeUnits.minutesFew;
    }
    return TimeUnits.minutesMany;
  }

  Future<List<Recipe>> _loadRecipesFromNet() async {
    List<Recipe> recipes = [];
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
      final photoBytes = await _networkClient.getImage(networkRecipe.photo);
      recipes.add(Recipe(
          id: networkRecipe.id,
          name: networkRecipe.name,
          photoUrl: networkRecipe.photo,
          duration:
              '${networkRecipe.duration} ${_calcRecipeDurationForm(networkRecipe.duration)}',
          steps: steps,
          ingredients: ingredients,
          photoBytes: photoBytes,
          comments: []));
    }
    return recipes;
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
      _recipeListSink.addError(SaveRecipeInfoException(e));
      return;
    }
    _recipeListSink.add(recipeList);
  }
}
