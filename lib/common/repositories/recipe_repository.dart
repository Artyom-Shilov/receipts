import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:receipts/common/exceptions/exceptions.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/local_storage/storage_models/local_recipe.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/repositories/model_converter.dart';
import 'package:rxdart/subjects.dart';
import 'base_recipe_repository.dart';

class RecipeRepository implements BaseRecipeRepository {
  RecipeRepository(
      {required BaseStorageRecipeClient storageClient,
      required BaseNetworkRecipeClient networkClient})
      : _storageClient = storageClient,
        _networkClient = networkClient,
        _converter = ModelsConverter(storageClient, networkClient);

  final BaseStorageRecipeClient _storageClient;
  final BaseNetworkRecipeClient _networkClient;
  final ModelsConverter _converter;

  final _recipeListStreamController = BehaviorSubject<List<Recipe>>();

  StreamSink<List<Recipe>> get _recipeListSink =>
      _recipeListStreamController.sink;

  @override
  Stream<List<Recipe>> get recipesStream => _recipeListStreamController.stream;

  @override
  List<Recipe> get currentRecipes => _recipeListStreamController.value;

  @override
  Future<void> loadRecipes() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    List<Recipe> appRecipes;
    List<LocalRecipe> localRecipes;
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      try {
        final networkRecipes = await _networkClient.getRecipes();
        appRecipes = await _converter.netRecipesToAppRecipes(networkRecipes);
        localRecipes = appRecipes.map((e) {
          return _converter.appRecipeToLocalRecipe(e);
        }).toList();
        await _storageClient.writeRecipes(localRecipes);
      } catch (e) {
        _recipeListSink.addError(LoadRecipesNetException(e));
        return;
      }
    } else {
      try {
        localRecipes = await _storageClient.readRecipes();
        appRecipes = localRecipes
            .map((e) => _converter.localRecipeToAppRecipe(e))
            .toList();
      } catch (e) {
        _recipeListSink.addError(LoadRecipesLocalException(e));
        return;
      }
      if (appRecipes.isEmpty) {
        _recipeListSink.addError(EmptyStorageException());
        return;
      }
    }
    _recipeListSink.add(appRecipes);
  }

  @override
  Future<void> saveRecipeInfo(Recipe recipe) async {
    List<Recipe> recipeList;
    try {
      await _storageClient
          .updateRecipe(_converter.appRecipeToLocalRecipe(recipe));
      recipeList = [...currentRecipes];
      int index = recipeList.indexWhere((element) => element.id == recipe.id);
      recipeList[index] = recipe;
    } catch (e) {
      _recipeListSink.addError(SaveRecipeInfoException(e));
      return;
    }
    _recipeListSink.add(recipeList);
  }

  @override
  Future<void> setLoggedUserFavouriteRecipes(User user) async {
    List<Recipe> actualRecipes;
    try {
      final userFavourites = (await _networkClient.getFavourites())
          .where((element) => element.user.id == user.id);
      final favouritesMap = {
        for (final favourite in userFavourites)
          favourite.recipe.id: favourite.id
      };
      actualRecipes = [...currentRecipes];
      for (int i = 0; i < actualRecipes.length; i++) {
        if (favouritesMap.keys.contains(actualRecipes[i].id)) {
          actualRecipes[i] = actualRecipes[i].copyWith(
              favouriteStatus: FavouriteStatus(
                  isFavourite: true,
                  favouriteId: favouritesMap[actualRecipes[i].id]));
        }
      }
    } catch (e) {
      _recipeListSink.addError(FetchFavouriteInfoException(e));
      return;
    }
    _recipeListSink.add(actualRecipes);
  }

  @override
  Future<void> loadComments() async {
    List<Recipe> actualRecipes;
    try {
      final netComments = await _networkClient.getComments();
      actualRecipes = [...currentRecipes];
      for (int i = 0; i < actualRecipes.length; i++) {
        final comments = <Comment>[];
        final filteredNetComments = netComments.where((element) =>
        element.recipe.id == actualRecipes[i].id);
        for (final netComment in filteredNetComments) {
          comments.add(await _converter.netCommentToAppComment(netComment));
        }
        actualRecipes[i] = actualRecipes[i].copyWith(comments: comments);
      }
    } catch (e) {
      _recipeListSink.addError(FetchCommentsException(e));
      return;
    }
    _recipeListSink.add(actualRecipes);
  }
}
