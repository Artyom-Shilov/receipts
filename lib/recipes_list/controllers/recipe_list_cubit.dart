import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';
import 'package:bloc/bloc.dart';
import 'package:receipts/recipes_list/services/base_recipe_service.dart';

class RecipeListCubit extends Cubit<RecipeListState>
    implements BaseRecipeListCubit {
  RecipeListCubit(this.recipeService)
      : super(const RecipeListState(
            loadingStatus: RecipeListLoadingStatus.initial, recipes: []));

  final BaseRecipeService recipeService;

  @override
  Future<void> loadRecipes() async {
    emit(state.copyWith(loadingStatus: RecipeListLoadingStatus.inProgress));
    List<Recipe> recipes;
    try {
      recipes = await recipeService.loadRecipes();
    } catch (e) {
      emit(state.copyWith(
          loadingStatus: RecipeListLoadingStatus.error, message: e.toString()));
      return;
    }
    emit(state.copyWith(
        loadingStatus: RecipeListLoadingStatus.done, recipes: recipes));
  }
}
