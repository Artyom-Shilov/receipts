import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/recipe/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/services/base_recipe_info_service.dart';

import 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState> implements BaseRecipeInfoCubit {

  RecipeInfoCubit(this._recipeInfoService)
      : super(const RecipeInfoState(searchStatus: RecipeSearchStatus.initial));

  final BaseRecipeInfoService _recipeInfoService;

  @override
  Future<void> findRecipe({required String id, required List<Recipe> recipes}) async {
    emit(state.copyWith(searchStatus: RecipeSearchStatus.inProgress));
    final Recipe recipe;
    try {
      recipe = await _recipeInfoService.getRecipeById(id: id, recipes: recipes);
    } catch (e) {
      emit(state.copyWith(searchStatus: RecipeSearchStatus.notFound));
      return;
    }
    emit(state.copyWith(searchStatus: RecipeSearchStatus.found, recipe: recipe));
  }
}