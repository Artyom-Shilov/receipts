import 'package:bloc/bloc.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';

abstract interface class BaseRecipeListCubit extends Cubit<RecipeListState> {
  BaseRecipeListCubit()
      : super(const RecipeListState(
            recipes: [], loadingStatus: RecipeListLoadingStatus.initial));

  Future<void> loadRecipes();
}