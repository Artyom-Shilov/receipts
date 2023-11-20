import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';

abstract interface class BaseRecipeListCubit extends Cubit<RecipeListState> {
  BaseRecipeListCubit(super.initialState);

  Future<void> loadRecipes();
  List<Recipe> get recipes;
  RecipeListStatus get status;
}