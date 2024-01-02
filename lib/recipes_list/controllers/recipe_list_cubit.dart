import 'dart:async';

import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/exceptions/exceptions.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';
import 'package:bloc/bloc.dart';

class RecipeListCubit extends Cubit<RecipeListState>
    implements BaseRecipeListCubit {
  RecipeListCubit(this.recipeRepository) : super(const RecipeListState(
            status: RecipeListStatus.initial, recipes: [])) {
    _recipeSubscription = recipeRepository.recipes.listen((recipeChanges) {
      emit(state.copyWith(recipes: recipeChanges, status: RecipeListStatus.success));
    }, onError: (e) {
      switch (e.runtimeType) {
        case EmptyStorageException:
          emit(state.copyWith(
              status: RecipeListStatus.error,
              message: ErrorMessages.emptyRecipeStorage));
        case SaveRecipeInfoException:
          emit(state.copyWith(
              status: RecipeListStatus.error,
              message: ErrorMessages.changeRecipeInfo));
        case LoadRecipesNetException:
          emit(state.copyWith(
              status: RecipeListStatus.error,
              message: ErrorMessages.loadRecipesNet));
        case LoadRecipesLocalException:
          emit(state.copyWith(
              status: RecipeListStatus.error,
              message: ErrorMessages.loadRecipesLocal));
        default:
          emit(state.copyWith(
              status: RecipeListStatus.error, message: ErrorMessages.common));
      }
    });
  }

  final BaseRecipeRepository recipeRepository;
  StreamSubscription<List<Recipe>>? _recipeSubscription;

  @override
  Future<void> loadRecipes() async {
    emit(state.copyWith(status: RecipeListStatus.inProgress));
    await recipeRepository.loadRecipes();
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
