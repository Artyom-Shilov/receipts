import 'dart:async';

import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/services/base_recipe_service.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';
import 'package:bloc/bloc.dart';

class RecipeListCubit extends Cubit<RecipeListState>
    implements BaseRecipeListCubit {

  RecipeListCubit(this.recipeService)
      : super(const RecipeListState(
            status: RecipeListStatus.initial, recipes: [])) {
    _recipeSubscription = recipeService.recipes.listen((event) {
      emit(state.copyWith(recipes: event, status: RecipeListStatus.success));
    }, onError: (_) => state.copyWith(status: RecipeListStatus.error));
  }

  final BaseRecipeService recipeService;
  StreamSubscription<List<Recipe>>? _recipeSubscription;

  @override
  Future<void> loadRecipes() async {
    emit(state.copyWith(status: RecipeListStatus.inProgress));
    await recipeService.loadRecipes();
    emit(state.copyWith(status: RecipeListStatus.error));
  }

  @override
  List<Recipe> get recipes => state.recipes;

  @override
  RecipeListStatus get status => state.status;

  @override
  Future<void> close() {
    _recipeSubscription?.cancel();
    return super.close();
  }
}
