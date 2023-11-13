import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:receipts/recipe_info/services/base_recipe_info_service.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState> implements BaseRecipeInfoCubit {

  RecipeInfoCubit(this._recipeInfoService)
      : super(const RecipeInfoState(searchStatus: RecipeSearchStatus.initial));

  final BaseRecipeInfoService _recipeInfoService;

  @override
  void findRecipe({required String id, required List<Recipe> recipes}) {
    emit(state.copyWith(searchStatus: RecipeSearchStatus.inProgress));
    final Recipe recipe;
    try {
      recipe = _recipeInfoService.getRecipeById(id: id, recipes: recipes);
    } catch (e) {
      emit(state.copyWith(searchStatus: RecipeSearchStatus.notFound));
      return;
    }
    emit(state.copyWith(searchStatus: RecipeSearchStatus.found, recipe: recipe));
  }
}